module Raterr
  class PeriodBuilder

    attr_reader :request, :period, :max

    class << self
      def call(request, period, max)
        new(request, period, max).build
      end
    end

    def initialize(request, period, max)
      @request = request
      @period = period
      @max = max
    end

    def build
      case period
      when :minute
        Raterr::Minute.new(request, max)
      when :hour
        Raterr::Hour.new((request, max))
      when :day
        Raterr::Day.new(request, max)
      when :week
        Raterr::Week.new(request, max)
      when :month
        Raterr::Month.new(request, max)
      else
        raise "Invalid limit period, available options are: #{Raterr::AVAILABLE_PERIODS.join(', ')}"
      end
    end
  end
end
