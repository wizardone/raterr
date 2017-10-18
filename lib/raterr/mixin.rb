require 'byebug'
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
        status: 200,
        attempts: attempts
      }
    end

    private

    def identifier
      # TODO: extend with other options from the request
      request.ip.to_s
    end

    def fetch_cache
      #StoreContainer.resolve(:fetch)
      case cache
      when Hash
        cache.fetch(identifier) { { attempts: 1, start_time: Time.now } }
      when Redis
        JSON.parse(cache.get(identifier) || { attempts: 1, start_time: Time.now }.to_json)
      end
    end

    def set_cache(value)
      #StoreContainer.resolve(:set)
      cache_attributes = {}.tap do |cache|
        cache[:attempts] = value
        cache[:start_time] = start_time
      end

      case cache
      when Hash
        cache[identifier] = cache_attributes
      when Redis
        cache.set(identifier, cache_attributes.to_json)
      end
    end

    def reset_cache
      cache.delete(identifier)
    end

    def cache
      #StoreContainer.new(Raterr.store)
      Raterr.store
    end

    def start_time
      fetch_cache[:start_time]
    end
  end
end
