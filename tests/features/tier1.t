group smaller-bricks
      # apply wildcard/regex
      include server[1-5]:/my/ssd
      # refer to other groups
      include rack2-bricks
end-group
