module RailsEmberRenderer
  class EmberAppVersionedBuild < EmberAppBuild
    attr_accessor :short_commit_sha
    attr_accessor :version

    def initialize(options)
      super(options)

      self.version = options.fetch(:version)
      self.short_commit_sha = options.fetch(:short_commit_sha)
    end

    def semver_version
      sanitized_version = self.version.sub(/v(\d)/, '\1') # SemVer doesn't recognize the 'v' prefix
      Semantic::Version.new(sanitized_version)
    end
  end
end
