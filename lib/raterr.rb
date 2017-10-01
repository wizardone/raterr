require 'raterr/version'

module Raterr

  AVAILABLE_PERIODS = [:minute, :hour, :day, :week, :month].freeze
  DEFAULTS = {
    attempts: 100,
    period: :hour
  }.freeze

  def self.enforce(request, **options)
    period = options[:period] || DEFAULTS[:period]
    max = options[:max] || DEFAULTS[:attempts]

    PeriodBuilder.call(request, period, max)
  end
end
