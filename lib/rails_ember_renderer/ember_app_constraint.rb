module RailsEmberRenderer
  class EmberAppConstraint
    attr_accessor :branch
    attr_accessor :commit_sha
    attr_accessor :is_from_request
    attr_accessor :version_range

    def initialize(options)
      self.branch = options.fetch(:branch, nil)
      self.commit_sha = options.fetch(:commit_sha, nil)
      self.is_from_request = options.fetch(:is_from_request, false)
      self.version_range = options.fetch(:version_range, nil)
    end

    def from_request?
      self.is_from_request
    end

    def satisfied_by?(ember_app_build)
      (
        self.branch_constraint_satisfied_by?(ember_app_build) &&
        self.commit_sha_constraint_satisfied_by?(ember_app_build) &&
        self.version_range_constraint_satisfied_by?(ember_app_build)
      )
    end

    protected

    def branch_constraint_satisfied_by?(ember_app_build)
      return true if self.branch.blank?

      ember_app_build.is_a?(EmberAppBranchBuild) && self.branch.eql?(ember_app_build.branch_name)
    end

    def commit_sha_constraint_satisfied_by?(ember_app_build)
      self.commit_sha.blank? || ember_app_build.short_commit_sha.eql?(self.short_commit_sha)
    end

    def sanitized_version_range
      self.version_range.sub(/v(\d)/, '\1') # SemVer doesn't recognize the 'v' prefix
    end

    def short_commit_sha
      self.commit_sha.slice(0, 8)
    end

    def version_range_constraint_satisfied_by?(ember_app_build)
      return true if self.version_range.blank?

      ember_app_build.is_a?(EmberAppVersionedBuild) && ember_app_build.semver_version.satisfies?(self.sanitized_version_range)
    end
  end
end
