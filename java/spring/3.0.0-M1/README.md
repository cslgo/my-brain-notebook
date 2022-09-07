
Spring官方于2022年1月20日发布Spring Boot 3.0.0-M1版本，预示开启了Spring Boot 3.0的里程碑，相信这是通往下一代Spring框架的激动人心的旅程。

接下来一起来看看Spring Boot 3.0.0-M1 版本都有哪些重大变化。

**Spring Boot 2.x 弃用**

Spring Boot 2.x中不推荐使用的类、方法和属性已在Spring Boot 3.0.0-M1版本中删除，注意在升级之前有没有调用过时的方法。

**最低要求变更**

Java基线从Java 8提升到Java 17。

Spring Boot 3.0需要Java 17和Spring Framework 6作为最低版本。

使用Gradle构建的应用程序需要Gradle 7.3或更高版本。

目前已删除对Jersey的支持，因为它尚不支持Spring Framework 6。

**升级到Jakarta EE 9**

Spring Boot 3.0 开始，如果使用 Spring Boot 3.0 的现有应用程序，需要注意Java EE API 已迁移到其他等效的 Jakarta EE 上。

对于大多数的开发人员来说，这将意味着需要将任何javax导入替换为jakarta，例如javax.servlet.Filter将替换为jakarta.servlet.Filter。

但是还有一些依赖Java EE API的第三方库，目前还没有得到很好的支持，所以在Spring Boot 3.0中暂时会移除这类组件的支持。

由于并不是所有Spring Boot 2.x功能都可用于第一个里程碑。Spring官方计划等第三方库发布jakarta兼容库之后重新引入功能。

Spring Boot依赖于Jakarta EE规范的地方，Spring Boot 3.0已升级到Jakarta EE 9中包含的版本。例如，Spring Boot 3.0使用Servlet 5.0和JPA 3.0规范。

为了区分支持Jakarta EE 8的模块和支持Jakarta EE 9的模块，一些项目发布了具有不同后缀ID的Jakarta EE 9兼容模块。例如，Undertow使用-jakartaee9后缀，而Hibernate使用-jakarta。

一般来说，Spring Boot的启动模块会自动处理这种更改。如果是直接声明对第三方模块的依赖项，则可能需要更新依赖项声明以适应使用与EE 9兼容的后缀ID。

作为此次升级到Jakarta EE 9的一部分，在无法获得第三方库的支持情况下，已经减少或删除了对某些依赖项的支持。

但是随着生态系统逐渐适应Jakarta EE 9中的新包名称，Spring 官方会重新引入支持。


目前已删除对以下内容的支持：

```
EhCache 3
H2’s web console
Hibernate’s metrics
Infinispan
Jolokia
Pooled JMS
REST Assured
```

**部分支持删除**

Spring Boot 3.0 中删除了对以下依赖项的支持:

```
Apache ActiveMQ
Atomikos
EhCache 2
Hazelcast 3
JSON-B
```
还删除Apache Johnzon的依赖管理，取而代之的是Eclipse Yasson。

注意的是Apache Johnzon的Jakarta EE 9兼容版本可以与Spring Boot 3一起使用，但是必须在依赖项声明中指定一个版本。

Spring Boot 3.0.0-M1迁移到Spring项目的依赖版本：

```
Micrometer 2.0.0-M1
Spring AMQP 3.0.0-M1
Spring Batch 5.0.0-M1
Spring Data 2022.0.0-M1
Spring Framework 6.0.0-M2
Spring Integration 6.0.0-M1
Spring HATEOAS 2.0.0-M1
Spring Kafka 3.0.0-M1
Spring LDAP 3.0.0-M1
Spring REST Docs 3.0.0-M1
Spring Security 6.0.0-M1
Spring Session 2022.0.0-M1
Spring Web Services 4.0.0-M1
```

许多第三方依赖项也已更新，其中一些值得注意的是：

```
Artemis 2.20.0
Hazelcast 5.0
Hibernate Validator 7.0
Jakarta Activation 2.0
Jakarta Annotation 2.0
Jakarta JMS 3.0
Jakarta JSON 2.0
Jakarta JSON Bind 3.0
Jakarta Mail 2.0
Jakarta Persistence 3.0
Jakarta Servlet 5.0
Jakarta Servlet JSP JSTL 2.0
Jakarta Transaction 2.0
Jakarta Validation 3.0
Jakarta WebSocket 2.0
Jakarta WS RS 3.0
Jakarta XML Bind 3.0
Jakarta XML Soap 2.0
Jetty 11
jOOQ 3.16
Tomcat 10
```


除了上面列出的更改之外，还有一些小的调整和改进，包括：

1. 对Java的SecurityManager支持，在JDK中被弃用后，Spring Boot 3.0.0-M1中已被删除；
2. 对Spring Framework的CommonsMultipartResolver的支持，在Spring Framework 6中删除后，Spring Boot 3.0.0-M1中也已经被删除。

Spring官方消息，计划每两个月发布一个新的Spring Boot 3.0里程碑，在今年3月24日发布Spring Boot 3.0.0-M2，计划在11月下旬发布GA版本。

如果感兴趣或者想尝试这个新版本的朋友，可以从start.spring.io生成一个项目，注意选择Java 17。有什么想说的欢迎下方留言！！

>参考资料：
>
>https://spring.io/blog/2022/01/20/spring-boot-3-0-0-m1-is-now-available
>




