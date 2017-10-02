require 'byebug'
module Raterr
  class Hour

    include Mixin

    MINUTES_PER_HOUR = 60.freeze

    def max_per_hour
      max
    end
    alias_method :max_per_period, :max_per_hour

    def rate_period
      start_time + 3600
    end

    def try_after
      "#{MINUTES_PER_HOUR - ((Time.now - start_time) / MINUTES_PER_HOUR).ceil} minutes"
    end
  end
end

