环境:

本地 local ： 个人开发环境  local分支 master 1 -> local 1...n （完全隔离，也可以借用研发环境资源局部隔离）
研发 dev ：   研发联调环境  dev 分支  所有feature分支local 1...n -> dev 1    初始 master 1 -> dev 1...n （上线后拉取 master 保持同步，过多无效feature时可丢弃从新初始化分支）
测试 qa ：    集成测试环境  qa分支    准备上线分支local 1...n - > qa 1       初始 master 1 -> qa 1...n （数据完全独立，避免研发干扰，由QA人员生产维护）
生产 prod ：  线上生产环境  maser分支 qa 1...n -> master 1 单线

原则是：单向循环 比如  dev -> local -> feature -> dev   dev -> master

```shell
() git add .
() git commit -m "init first"
## 本地环境 feature 1
(master) git checkout -b f1
(f1) git commit -m ""
(f1) git checkout master
## 本地环境 feature 2
(master) git checkout -b f2
(f2) git commit -m ""
(f2) git checkout master
## 本地环境 feature 3
(master) git checkout -b f3
(f3) git commit -m ""
(f3) git checkout master
## 开发环境 联调分支
(master) git checkout -b dev
##  联调 f1
(dev) git merge f1
##  联调 f2
(dev) git merge f2
(dev) git checkout master
## QA环境 集成测试  
(master) git checkout -b qa1
(qa1) git merge f1
(qa1) git merge f2
## 集成测试通过，准备上线，上线前做 merge master 冲突处理
(qa1) git merge master
(qa1) git checkout master
(master) git merge qa1

```

问题场景 ：

本地分支代码，不可能保持与其它分支代码保持同步
   
1. 为了验证本地分支的整体功能及联调，可能把本地分支打包部署研发环境，导致其它分支代码覆盖 ，解决方案是：各分支统一合并到dev分支再做部署
2. 使用dev分支 合并到master分支打包上线，由于第一步操作，dev含有各不打算上线feature，方案不合理，解决方案：