group brick1
      include gprfs023:/mnt/t1
end-group
group brick2
      include gprfs023:/mnt/t2
end-group
group brick3
      include gprfs023:/mnt/t3
end-group
group brick4
      include gprfs023:/mnt/t4
end-group
group brick5
      include gprfs023:/mnt/t5
end-group
group brick6
      include gprfs023:/mnt/t6
end-group
group brick7
      include gprfs023:/mnt/t7
end-group
group brick8
      include gprfs023:/mnt/t8
end-group
group replica-sets-1
      combine brick1, brick2
      type cluster/replicate
      option lookup-unhashed on
end-group
group replica-sets-2
      combine brick3, brick4
      type cluster/replicate
      option lookup-unhashed on
end-group
group replica-sets-3
      combine brick5, brick6
      type cluster/replicate
      option lookup-unhashed on
end-group
group replica-sets-4
      combine brick7, brick8
      type cluster/replicate
      option lookup-unhashed on
end-group
group dht-set-1
      combine replica-sets-1,replica-sets-2
      type cluster/dht
      option lookup-unhashed on
end-group
group dht-set-2
      combine replica-sets-3,replica-sets-4
      type cluster/dht
      option lookup-unhashed on
end-group
group tier-1
      combine dht-set-1, dht-set-2
      type cluster/cache_tier
      option rule *.lock
      option xattr-name trusted.glusterfs.tier
end-group
