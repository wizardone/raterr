module Raterr
  class PeriodBuilder

    attr_reader :request, :period, :options

    class << self
      def call(request, options)
        new(request, options).build
      end
    end

    def initialize(request, options)
      @period = options[:period] || DEFAULTS[:period]
      @request = request
      @options = options
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
      klass.new(request, options)
    end
  end
end
