module Raterr
  class StoreContainer

    STORE_RETRIEVAL_METHODS = %w(get set delete).freeze

    attr_reader :store, :store_type

    def initialize(store)
      @store = store
      @store_type = store.class.to_s
      register_store_methods
    end

    private

    def register_store_methods
      STORE_RETRIEVAL_METHODS.each {|method| register(method)}
    end

    # Register something like:
    # StoreContainer.register(:get, -> { store.fetch })
    def register(method)

    end

    def resolve(method, args)

    end
  end
end
