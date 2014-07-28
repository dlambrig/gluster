group sanlock
      combine replica3-part, replica2-part
      type features/filter
      # matches go to first subvolume
      # everything else goes to second
      option filter-pattern *.lock
end-group
