# [redis-cli](https://redis.io/topics/rediscli)

```shell
docker exec developenv_redis_1 redis-cli -a Vn_1aas incr mycounter
docker exec developenv_redis_1 redis-cli -a Vn_1aas incr mycounter > /tmp/output.txt
docker exec developenv_redis_1 redis-cli -a Vn_1aas --raw incr mycounter
docker exec developenv_redis_1 redis-cli -a Vn_1aas ping 
docker exec developenv_redis_1 redis-cli -u redis://Vn_1aas@localhost:6379 ping
docker exec developenv_redis_1 redis-cli -u redis://Vn_1aas@localhost:6379/0 ping
docker exec developenv_redis_1 redis-cli -a Vn_1aas flushall
docker exec developenv_redis_1 redis-cli -a Vn_1aas -x set foo < /etc/services
docker exec developenv_redis_1 redis-cli -a Vn_1aas getrange foo 0 50
cat /tmp/commands.txt
cat /tmp/commands.txt | docker exec developenv_redis_1 redis-cli -a Vn_1aas
# Continuously run the same command
docker exec developenv_redis_1 redis-cli -a Vn_1aas -r 5 incr foo
# To run the same command forever, use -1 as count.
docker exec developenv_redis_1 redis-cli -a Vn_1aas -r -1 -i 1 INFO | grep rss_human
# CSV output
docker exec developenv_redis_1 redis-cli -a Vn_1aas lpush mylist a b c d
docker exec developenv_redis_1 redis-cli -a Vn_1aas --csv lrange mylist 0 -1
# Running Lua scripts
# cat /tmp/script.lua
# return redis.call('set',KEYS[1],ARGV[1])
docker exec developenv_redis_1 redis-cli -a Vn_1aas --eval /tmp/script.lua foo , bar
# Interactive mode
docker exec -it developenv_redis_1 redis-cli
    127.0.0.1:6379> select 2
    127.0.0.1:6379[2]> dbsize
    127.0.0.1:6379[2]> select 0
    127.0.0.1:6379> dbsize
    # connect to a different instance
    127.0.0.1:6379> connect metal 6379
    127.0.0.1:6379> connect 127.0.0.1 9999
    # disconnection and reconnection
    127.0.0.1:6379> debug restart
    # Running the same command N times
    127.0.0.1:6379> 5 incr mycounter
    # Showing help about Redis commands
    127.0.0.1:6379> help PFADD
# Continuous stats mode
docker exec developenv_redis_1 redis-cli -a Vn_1aas --stat
# Scanning for big keys
docker exec developenv_redis_1 redis-cli -a Vn_1aas --bigkeys
# Getting a list of keys 
docker exec developenv_redis_1 redis-cli -a Vn_1aas --scan | head -10
docker exec developenv_redis_1 redis-cli -a Vn_1aas --scan --pattern '*-11*'
docker exec developenv_redis_1 redis-cli -a Vn_1aas --scan --pattern 'user:*' | wc -l
# Pub/sub mode
docker exec developenv_redis_1 redis-cli -a Vn_1aas psubscribe '*'
# Monitoring commands executed in Redis
docker exec developenv_redis_1 redis-cli -a Vn_1aas monitor
# Monitoring the latency of Redis instances
docker exec developenv_redis_1 redis-cli -a Vn_1aas --latency
docker exec developenv_redis_1 redis-cli -a Vn_1aas --latency-history
docker exec developenv_redis_1 redis-cli -a Vn_1aas --latency-dist
docker exec developenv_redis_1 redis-cli -a Vn_1aas --intrinsic-latency 5
# Remote backups of RDB files
docker exec developenv_redis_1 redis-cli -a Vn_1aas --rdb /tmp/dump.rdb
# Replica mode
docker exec developenv_redis_1 redis-cli -a Vn_1aas --replica
# Performing an LRU simulation 
docker exec developenv_redis_1 redis-cli -a Vn_1aas --lru-test 10000000

```


Interactive mode

```shell
# HELP @<category> shows all the commands about a given category. The categories are:
# @generic
# @string
# @list
# @set
# @sorted_set
# @hash
# @pubsub
# @transactions
# @connection
# @server
# @scripting
# @hyperloglog
# @cluster
# @geo
# @stream
# HELP <commandname> shows specific help for the command given as argument.
> HELP PFADD
# cmd in
./redis-cli
> AUTH ***
> KEYS pattern*
> INFO SERVER
> CONNECT 127.0.0.1 9999
> MULTI
> PING
# Running the same command N times
> 5 INCR mycounter
# Clearing the terminal screen
> CLEAR


```