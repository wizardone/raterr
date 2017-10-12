require 'active_support'
require 'redis'
require 'raterr/version'
require 'raterr/period_builder'
require 'raterr/mixin'
require 'raterr/hour'
require 'raterr/day'
require 'raterr/minute'

module Raterr

  InvalidStore = Class.new(StandardError)

  AVAILABLE_PERIODS = [:minute, :hour, :day, :week, :month].freeze
  DEFAULTS = {
    max: 100,
    code: 429,
    message: "Rate limit exceeded. Try again in %{time}.",
    period: :hour
  }.freeze

  class << self

    attr_accessor :store

    def enforce(request, **options)
      unless store.is_a?(Hash) ||
             store.is_a?(::ActiveSupport::Cache::MemoryStore) ||
             store.is_a?(::Redis)
        raise InvalidStore.new('Store is not valid, please refer to the documentation')
      end

      period = PeriodBuilder.call(request, options)
      period.allowed? ? period.proceed : period.rate_limit_exceeded
    end
  end
end
