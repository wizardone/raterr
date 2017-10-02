require 'byebug'
module Raterr
  class Minute

    include Mixin

    SECONDS_PER_MINUTE = 60.freeze

    def max_per_minutes
      max
    end
    alias_method :max_per_period, :max_per_minutes

    def rate_period
      start_time + SECONDS_PER_MINUTE
    end

    def try_after
      "#{SECONDS_PER_MINUTE - (Time.now - start_time).ceil} seconds"
    end
  end
end
