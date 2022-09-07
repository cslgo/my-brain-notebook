
云原生消息队列Pulsar浅析
===


## 一、前言

Pulsar是一个多租户，高性能的服务间消息解决方案。最初由Yahoo开发，现在由Apache Software Foundation负责。
Pulsar是消息队列领域的一匹黑马，其最大优点在于它提供了比Apache Kafka更简单明了、更健壮的一系列操作功能，支持地域复制和多租户。此外，相比传统的Kafka、RocketMQ等，Pulsar更加适合IoT的场景。


## 二、架构设计

### 2.1 整体架构

Apache Pulsar 和其他消息系统最根本的不同是采用分层架构。 
Apache Pulsar 集群由两层组成：
无状态服务层：由一组接收和传递消息的Broker组成
有状态持久层：由一组Apache BookKeeper存储节点组成，可持久化地存储消息。





## Reference Link
https://developer.aliyun.com/article/927773

