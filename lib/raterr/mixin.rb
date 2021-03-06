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
      fetch_cache['attempts'] <= max_per_period
    end

    def proceed
      attempts = fetch_cache['attempts'] + 1
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
      container.resolve(:get)
    end

    def set_cache(value)
      cache_attributes = {}.tap do |cache|
        cache['attempts'] = value
        cache['start_time'] = start_time
      end

      container.resolve(:set, cache_attributes)
    end

    def reset_cache
      container.resolve(:delete, identifier)
    end

    def container
      @container ||= StoreContainer.new(store: Raterr.store, identifier: identifier)
    end

    def start_time
      start_time = fetch_cache['start_time']
      # Depending on the storage option start_time can be
      # either a Time object or a string
      return Time.parse(start_time) if start_time.is_a?(String)
      start_time
    end
  end
end
