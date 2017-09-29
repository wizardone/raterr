require 'raterr/version'

module Raterr

  attr_reader :request, :period, :max

  AVAILABLE_PERIODS = [:minute, :hour, :day, :week, :month].freeze
  DEFAULT_MAX = 100.freeze

  def self.enforce(request, **options)
    @request = request
    @period = options[:period] || :hour
    @max = options[:max] || 100
    PeriodBuilder.new(request, options)
  end
end
