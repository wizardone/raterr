require 'byebug'
module Raterr
  class Day

    include Mixin

    HOURS_PER_DAY = 24.freeze

    private

    def max_per_day
      options[:max]
    end
    alias_method :max_per_period, :max_per_day

    def rate_period
      start_time + 3600 * HOURS_PER_DAY
    end

    def try_after
      "#{HOURS_PER_DAY - ((Time.now - start_time) / 3600).ceil} hours"
    end
  end
end


