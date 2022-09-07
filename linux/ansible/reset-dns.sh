#!/bin/bash

regex="\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\b"

ck=`echo $1 | egrep $regex | wc -l`

if [ $ck -eq 0 ]
then
    echo "The string $DNS is not a correct ipaddr!!!"
else
    sed -i s/^DNS1=.*/DNS1=\"$1\"/g /etc/sysconfig/network-scripts/ifcfg-ens33
    service network restart
fi