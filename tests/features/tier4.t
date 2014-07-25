group tier-1
      combine replica-sets
      # no size, so consume all
      type cluster/dht
      option lookup-unhashed on
      # result is a singleton group
end-group