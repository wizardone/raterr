require 'byebug'
module Raterr
  class Minute

    include Mixin

    def max_per_minutes
      max
    end
    alias_method :max_per_period, :max_per_minutes

    def try_after(time_exceeded)
      "#{60 - (time_exceeded - start_time).ceil} seconds"
    end
  end
end
