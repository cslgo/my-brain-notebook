分布式链路
===

## 为什么需要链路追踪

在学习分布式链路追踪之前，我们需要先理解这项技术产生的背景，以及它能够帮我们解决哪些棘手问题。

提到分布式链路追踪，我们要先提到微服务。相信很多人都接触过微服务，这里再回顾一下基本概念。

微服务是一种开发软件的架构和组织方法，它侧重将服务解耦，服务之间通过API通信。使应用程序更易于扩展和更快地开发，从而加速新功能上线。

加速研发快速迭代，让微服务在业务驱动的互联网领域全面普及，独领风骚。但是，随之而来也产生了新问题：当生产系统面对高并发，或者解耦成大量微服务时，以前很容易就能实现的监控、预警、定位故障就变困难了。

## 什么是分布式链路追踪

刚才说的情况，我们迫切需要一些新工具，帮我们理解微服务分布式系统的行为、精准分析性能问题。于是，分布式系统下链路追踪技术（Distributed Tracing）出现了。

它的核心思想是：在用户一次请求服务的调⽤过程中，无论请求被分发到多少个子系统中，子系统又调用了更多的子系统，我们把系统信息和系统间调用关系都追踪记录下来。最终把数据集中起来可视化展示。它会形成一个有向图的链路，看起来像下面这样。

后来，链路追踪技术相关系统慢慢成熟，涌现了像Dapper、Zipkin、HTrace、OpenTelemetry等优秀开源系统。他们也被业界，特别是互联网普遍采用。

目前Dapper（诞生于Google团队）应用影响最大，OpenTelemetry已经成为最新业界标准，我们重点基于OpenTelemetry讲解一下Trace内部结构。

## 链路Trace的核心结构

**Trace数据模型**

我们看看Trace广义的定义：Trace是多个 Span 组成的一个有向无环图（DAG），每一个 Span 代表 Trace 中被命名并计时的连续性的执行片段。我们一般用这样数据模型描述Trace和Span关系：

```
              [Span user click]  ←←←(the root Span)
                       |         
                 [Span gateway]  
                       |
     +------+----------+-----------------------+
     |                 |                       |
 [Span auth]      [Span billing]     [Span loading resource] 
```
数据模型包含了Span之间关系。Span定义了父级Span，子Span的概念。一个父级的Span会并行或者串行启动多个子Span

**Span基本结构**

前面提到Span通俗概念：一个操作，它代表系统中一个逻辑运行单元。Span之间通过嵌套或者顺序排列建立因果关系。Span包含以下对象：

* 操作名称Name：这个名称简单，并具有可读性高。例如：一个RPC方法的名称，一个函数名，或者一个大型计算过程中的子任务或阶段
* 起始时间和结束时间：操作的生命周期
* 属性Attributes：一组<K,V>键值对构成的集合。值可以是字符串、布尔或者数字类型，一些链路追踪系统也称为Tags
* 事件Event
* 上下文 SpanContext：Span上下文内容
* 链接Links：描述Span节点关系的连线，它的描述信息保存在SpanContext中

**属性Attributes：**

我们分析一个Trace，通过Span里键值对<K,V>形式的Attributes获取基本信息。为了统一约定，Span提供了基础的Attributes。比如，Span有下面常用的Attributes属性：

* 网络连接Attributes：这些Attributes用在网络操作相关
* 线程Attribute

这些Attributes记录了启动一个Span后相关线程信息。考虑到系统可以是不同开发语言，相应还会记录相关语言平台信息。

记录线程信息，对于我们排查问题时候非常必要的，当出现一个程序异常，我们至少要知道它什么语言开发，找到对于研发工程师。研发工程师往往需要线程相关信息快速定位错误栈。

**Span间关系描述Links：**

我们看看之前Span数据模型：

```
                [Span gateway]
                   |     
     +------+------+------------------+ 
     |             |                  |
 [Span auth]  [Span billing]     [Span loading resource]
```

一个Trace有向无环图，Span是图的节点，链接就是节点间的连线。可以看到一个Span节点可以有多个Link，这代表它有多个子Span。

Trace定义了Span间两种基本关系：

* ChildOf：Span A是Span B的孩子，即“ChildOf”关系
* FollowsFrom：Span A是Span B的父级Span

**Span上下文信息SpanContext：**

字面理解Span上下文对象。它作用就是在一个Trace中，把当前Span和Trace相关信息传递到下级Span。它的基本结构类似<Trace_id, Span_id, sampled> ，每个SpanContext包含以下基本属性：

* TraceId：随机16字节数组。比如：4bf92f3577b34da6a3ce929d0e0e4736
* SpanId：随机8字节数组。比如：00f067aa0ba902b7
* Baggage Items是存在于Trace一个键值对集合，也需要Span间传输。

**Trace链路传递初探**

在一个链路追踪过程中，我们一般会有多个Span操作，为了把调用链状态在Span中传递下去，期望最终保存下来，比如打入日志、保存到数据库。SpanContext会封装一个键值对集合，然后将数据像行李一样打包，这个打包的行李OpenTelemetry称为Baggage（背包）。

Baggage会在一条追踪链路上的所有Span内全局传输。在这种情况下，Baggage会随着整个链路一同传播。我们可以通过Baggage实现强大的追踪功能。

方便理解，我们用开账单服务演示Baggage效果：

首先，我们在LoadBalancer请求中加一个Baggage，LoadBalancer请求了source服务。

```java
@GetMapping("/loadBalancer")
@ResponseBody
public String loadBalancer(String tag){
    Span span = Span.current();   
    //保存 Baggage
 Baggage.current()
   .toBuilder()
   .put("app.username", "蒋志伟")
   .build()
   .makeCurrent();
......
    ##请求 resource
httpTemplate.getForEntity(APIUrl+"/resource",String.class).getBody();  
```
然后我们从resource服务中获取Baggage信息，并把它存储到Span的Attributes中。
```java
@GetMapping("/resource")
@ResponseBody
public String resource(){
 String baggage = Baggage.current().getEntryValue("app.username");
 Span spanCur = Span.current(); 
    ##获取当前的 Span，把 Baggage 写的 resource
 spanCur.setAttribute("app.username", 
                         "baggage 传递过来的 value: "+baggage); 
```
最终，我们从跟踪系统的链路UI中点击source这个Span，找到传递的Baggage信息。


## 作者介绍

蒋志伟，爱好技术的架构师，先后就职于阿里、Qunar、美团，前pmcaffCTO，目前Opentelemetry中国社区发起人，https://github.com/open-telemetry/docs-cn主要维护者。




