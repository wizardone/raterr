module Raterr
  class PeriodBuilder

    attr_reader :request, :period, :max

    class << self
      def call(request, options)
        new(request, options).build
      end
    end

    def initialize(request, options)
      @period = options[:period] || DEFAULTS[:period]
      @max = options[:max] || DEFAULTS[:max]
      @request = request
    end

    def build
      klass = case period
        when :minute
          Raterr::Minute
        when :hour
          Raterr::Hour
        when :day
          Raterr::Day
        else
          raise "Invalid limit period, available options are: #{Raterr::AVAILABLE_PERIODS.join(', ')}"
        end
      klass.new(request,  max)
    end
  end
end
