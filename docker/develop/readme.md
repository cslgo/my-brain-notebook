
# 启动 nexus3

```shell
docker run -d --name nexus3 --restart=always \
    -p 8081:8081 \
    --mount src=/opt/data/nexus,target=/nexus-data \
    sonatype/nexus3
```


# 首次运行请通过以下命令获取初始密码

```shell
$ docker exec nexus3 cat /nexus-data/admin.password
```

# 创建仓库

# connecting via redis-cli

```shell
# docker run -it --network some-network --rm redis redis-cli -h some-redis
docker run -it --rm redis redis-cli -h some-redis

# or
docker exec -it developenv_redis_1 redis-cli
```



