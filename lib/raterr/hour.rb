require 'byebug'
module Raterr
  class Hour

    include Mixin

    def max_per_hour
      max
    end
    alias_method :max_per_period, :max_per_hour

    def try_after(time_exceeded)
      "#{60 - ((time_exceeded - start_time) / 60).ceil} minutes"
    end
  end
end

