Network Configuration
===

Network settings

```bash
$ ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 02:42:77:bc:a1:41  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.10  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fe1b:53d8  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:1b:53:d8  txqueuelen 1000  (Ethernet)
        RX packets 1229  bytes 423542 (423.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 789  bytes 100191 (100.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 270  bytes 23308 (23.3 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 270  bytes 23308 (23.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:1b:53:d8 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:77:bc:a1:41 brd ff:ff:ff:ff:ff:ff

$ ip route
default via 10.10.10.2 dev ens33 proto dhcp src 10.10.10.10 metric 100 
10.10.10.0/24 dev ens33 proto kernel scope link src 10.10.10.10 metric 100 
10.10.10.2 dev ens33 proto dhcp scope link src 10.10.10.10 metric 100

$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.10.10.2      0.0.0.0         UG    100    0        0 ens33
10.10.10.0      0.0.0.0         255.255.255.0   U     100    0        0 ens33
10.10.10.2      0.0.0.0         255.255.255.255 UH    100    0        0 ens33

$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:1b:53:d8 brd ff:ff:ff:ff:ff:ff
    altname enp2s1
    inet 10.10.10.10/24 metric 100 brd 10.10.10.255 scope global dynamic ens33
       valid_lft 1220sec preferred_lft 1220sec
    inet6 fe80::20c:29ff:fe1b:53d8/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:77:bc:a1:41 brd ff:ff:ff:ff:ff:ff
```

