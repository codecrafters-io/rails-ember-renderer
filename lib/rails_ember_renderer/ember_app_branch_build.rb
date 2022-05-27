module RailsEmberRenderer
  class EmberAppBranchBuild < EmberAppBuild
    attr_accessor :branch_name
    attr_accessor :short_commit_sha

    def initialize(options)
      super(options)

      self.branch_name = options.fetch(:branch_name)
      self.short_commit_sha = options.fetch(:short_commit_sha)
    end
  end
end
