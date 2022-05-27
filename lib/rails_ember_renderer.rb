# frozen_string_literal: true

require_relative "rails_ember_renderer/version"
require_relative "rails_ember_renderer/ember_app_build"
require_relative "rails_ember_renderer/ember_app_branch_build"
require_relative "rails_ember_renderer/ember_app_development_build"
require_relative "rails_ember_renderer/ember_app_versioned_build"
require_relative "rails_ember_renderer/ember_app_constraint"
require_relative "rails_ember_renderer/ember_app_store"

require "rails_ember_renderer/helper" if defined?(Rails::Railtie)

module RailsEmberRenderer
  class Error < StandardError; end
  class BuildNotFoundError < Error; end

  def configure
    yield RailsEmberRenderer::Configuration.instance
  end
end
