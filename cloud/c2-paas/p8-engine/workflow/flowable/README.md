Flowable
===
工作流引擎
---

五大引擎：

1. ContentEngine 内容引擎
2. IdmEngine 身份识别引擎
3. FormEngine 表单引擎
4. DmnEngine 决策引擎
5. ProcessEngine 流程引擎

## ContentEngine 内容引擎

ContentManagementService 实现对数据库表的管理操作

- `Map<String, Long> getTableCount()` 获取每个表的记录数量；
- `String getTableName(Class<?> flowableEntityClass)` 根据实体类获得对应的数据库表名；
- `TableMetaData getTableMetaData(String tableName)` 根据数据库表名获得表的列名和列类型；
- `TablePageQuery createTablePageQuery()` 创建一个可以进行排序、根据条件分页的查询类。


ContentService 实现对内容的创建、删除、保存和获取的基本操作

ContentEngineConfiguration 提供Mybatis的封装，实现数据库相关配置的获取。

同时，内容引擎配置还提供了操作系统级的文件操作的路径设置、文件读取、文件保存的功能。

## IdmEngine 身份识别引擎

IdmIdentityService

提供用户的创建、修改、删除、密码修改、登录、用户头像设置等；
提供组Group的创建、删除、用户与组关系的关联、删除关联；
提供权限的创建、删除、关联等。

IdmManagementService

对身份识别相关的数据库表进行统计、获取表的列信息。

IdmEngineConfiguration

提供数据库配置信息。

## FormEngine 表单引擎

FormManagementService

FormRepositoryService

FormService

FormEngineConfiguration


## DmnEngine 决策引擎

DmnManagementService

DmnRepositoryService

DmnRuleService

DmnHistoryService

DmnEngineConfiguration

## ProcessEngine 流程引擎

RepositoryService

RuntimeService

HistoryService

IdentityService

TaskService

FormService

ManagementService

DynamicBpmnService



