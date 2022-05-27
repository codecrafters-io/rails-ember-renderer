module RailsEmberRenderer
  class EmberAppBuild
    attr_accessor :redis_key
    attr_accessor :redis_store

    def initialize(options)
      self.redis_key = options.fetch(:redis_key)
      self.redis_store = options.fetch(:redis_store)
    end

    def index_html
      @index_html ||= self.redis_store.get(self.redis_key)
    end
  end
end
