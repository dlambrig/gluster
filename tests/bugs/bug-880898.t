#!/bin/bash

. $(dirname $0)/../include.rc

cleanup;

TEST glusterd
TEST $CLI volume create $V0 replica 2 $H0:$B0/brick1 $H0:$B0/brick2
TEST $CLI volume start $V0
pkill glusterfs
uuid=""
for line in $(cat $GLUSTERD_WORKDIR/glusterd.info)
do
	if [[ $line == UUID* ]]
	then
		uuid=`echo $line | sed -r 's/^.{5}//'`
	fi
done

gluster volume heal $V0 info | grep "Status: self-heal-daemon is not running on $uuid";
EXPECT "0" echo $?

cleanup;
