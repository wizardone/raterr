module Raterr
  module Mixin

    attr_reader :request, :options

    def initialize(request, options)
      @request = request
      @options = options
    end

    def rate_limit_exceeded
      {
        status: options[:code] || Raterr::DEFAULTS[:code],
        text: Raterr::DEFAULTS[:message] % { time: try_after }
      }
    end

    def allowed?
      reset_cache if Time.now > rate_period
      fetch_cache[:attempts] <= max_per_period
    end

    def proceed
      attempts = fetch_cache[:attempts] + 1
      set_cache(attempts)

      {
        attempts: attempts
      }
    end

    private

    def identifier
      # TODO: extend with other options from the request
      request.ip.to_s
    end

    def fetch_cache
      cache.fetch(identifier) { { attempts: 1, start_time: Time.now } }
    end

    def set_cache(value)
      cache_attributes = {}.tap do |cache|
        cache[:attempts] = value
        cache[:start_time] = start_time
      end
      cache.is_a?(Hash) ? cache[identifier] = cache_attributes :
                          cache.write(identifier, cache_attributes)
    end

    def reset_cache
      cache.delete(identifier)
    end

    def cache
      Raterr.store
    end

    def start_time
      fetch_cache[:start_time]
    end
  end
end
