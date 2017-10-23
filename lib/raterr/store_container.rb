module Raterr
  class StoreContainer

    STORE_RETRIEVAL_METHODS = %w(get set delete).freeze

    RESOLVERS = {
      get: {
        regular: -> { store.fetch(identifier) { { attempts: 1, start_time: Time.now } } },
        redis: -> { JSON.parse(cache.get(identifier) || { attempts: 1, start_time: Time.now }.to_json) }
      },
      set: {
        regular: -> (attributes) { store[identifier] = attributes },
        redis: -> { store.set(identifier, cache_attributes.to_json) }
      },
      delete: {
        regular: -> { store.delete(identifier) },
        redis: ''
      }
    }

    attr_reader :store, :store_type

    def initialize(store)
      @store = store
      @store_type = store.class.to_s.downcase.to_sym
    end

    def resolve(method, attrs = nil)
      RESOLVERS[method][store_type].call(attrs)
    end
  end
end
