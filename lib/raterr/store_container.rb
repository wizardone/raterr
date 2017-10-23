require 'byebug'
module Raterr
  class StoreContainer

    STORE_RETRIEVAL_METHODS = %w(get set delete).freeze

    attr_reader :store, :store_type, :identifier

    def initialize(store:, identifier:)
      @store = store
    end

    def resolve(method, attrs = nil)
      store_type = store.class.to_s.downcase.to_sym
      resolvers[method][store_type].call(attrs)
    end

    def resolvers
      {
        get: {
          hash: -> (attributes) { store.fetch(identifier) { { attempts: 1, start_time: Time.now } } },
          redis: -> (attributes) { JSON.parse(cache.get(identifier) || { attempts: 1, start_time: Time.now }.to_json) }
        },
        set: {
          hash: -> (attributes) { store[identifier] = attributes },
          redis: -> (attributes) { store.set(identifier, attributes.to_json) }
        },
        delete: {
          hash: -> { store.delete(identifier) },
          redis: ''
        }
      }
    end
  end
end
