require 'byebug'
module Raterr
  module Mixin

    attr_reader :request, :max

    def initialize(request, max)
      @request = request
      @max = max
    end

    def rate_limit_exceeded
      {
        status: Raterr::DEFAULTS[:code],
        text: Raterr::DEFAULTS[:message] % { time: try_after(Time.now) }
      }
    end

    def identifier
      # TODO: extend with other options from the request
      request.ip.to_s
    end

    def allowed?
      attempts = fetch_cache[:attempts]
      attempts <= max_per_period
    end

    def proceed
      attempts = fetch_cache[:attempts]
      set_cache(attempts + 1)
    end

    private

    def fetch_cache
      cache.fetch(identifier) { { attempts: 1, start_time: Time.now } }
    end

    def set_cache(value)
      cache_attributes = {}.tap do |cache|
        cache[:attempts] = value
        cache[:start_time] = start_time
      end

      cache.write(identifier, cache_attributes)
    end

    def cache
      Raterr::Cache.store
    end

    def start_time
      fetch_cache[:start_time]
    end
  end
end
