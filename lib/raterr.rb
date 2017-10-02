require 'raterr/version'
require 'raterr/cache'
require 'raterr/period_builder'
require 'raterr/mixin'
require 'raterr/minute'
require 'raterr/hour'
require 'raterr/day'
require 'raterr/minute'

module Raterr

  AVAILABLE_PERIODS = [:minute, :hour, :day, :week, :month].freeze
  DEFAULTS = {
    max: 100,
    code: 429,
    message: "Rate limit exceeded. Try again in %{time}.",
    period: :hour,
    name: 'rate_limit_attempts'
  }.freeze

  def self.enforce(request, **options)
    period = PeriodBuilder.call(request, options)
    period.allowed? ? period.proceed : period.rate_limit_exceeded
  end
end
