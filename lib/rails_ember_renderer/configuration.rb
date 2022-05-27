module RailsEmberRenderer
  class Configuration
    include Singleton

    attr_accessor :default_ember_app_name
    attr_accessor :default_ember_app_version_range
    attr_accessor :default_ember_app_branch

    attr_accessor :ember_store

    def redis_url=(redis_url)
      self.ember_store = EmberAppStore.new(Redis.new(url: redis_url))
    end
  end
end
