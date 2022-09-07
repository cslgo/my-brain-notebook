Gitlab Runner Chat Sheet
===

## 注册相关命令
```bash
gitlab-runner register      #交互模式下使用，非交互模式 --non-interactice
gitlab-runner list           
gitlab-runner verify        #检查注册runner十分是否可以连接，但不验证gitlab服务是否正在使用 runner.--delete删除
gitlab-runner unregister    #取消以及已注册的runner

#使用令牌注销
gitlab-runner unregister --url http://gitlab.example.com/ --token tok3n

#使用名称注销（同名删除一个）
gtlab-runner  unregister --name test-runner

#注销所有
gitlab-runner   unregister --all-runners
```

## 服务管理命令

```bash
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
#--user指定将用于执行构建的用户
#--working-directory指定使用shellexecutor运行构建时所有数据将存储在其中的根目录
gitlab-runneruninstall 停止运行并从服务中卸载gitlabrunner
gitlab-runner start    启动gitlab-runner
gitlab-runner stop     关闭gitlab-runner
gitlab-runner restart  重启gitlab-runner 
gitlab-runner status   查看gitlab-runner状态，当服务正在运行时，退出代码为零，而当服务未运行时，退出代码为非零。
```