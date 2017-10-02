require 'byebug'
module Raterr
  class Day

    include Mixin

    def max_per_day
      max
    end
    alias_method :max_per_period, :max_per_day

    def try_after(time_exceeded)
      "#{60 - ((time_exceeded - start_time) / 60).ceil} minutes"
    end
  end
end


