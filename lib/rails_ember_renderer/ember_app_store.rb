module RailsEmberRenderer
  class EmberAppStore
    def initialize(redis_store)
      @redis_store = redis_store
    end

    def get_branch_builds(app_name, branch_name)
      revisions = @redis_store.zrange(self.branch_build_revisions_key(app_name, branch_name), 0, -1)

      revisions.map do |revision|
        EmberAppBranchBuild.new(
          branch_name: branch_name,
          redis_key: self.branch_build_key(app_name, branch_name, revision),
          redis_store: @redis_store,
          short_commit_sha: revision
        )
      end
    end

    def get_development_build(app_name)
      if @redis_store.exists(self.development_build_key(app_name))
        EmberAppDevelopmentBuild.new(redis_key: self.development_build_key(app_name), redis_store: @redis_store)
      end
    end

    def get_versioned_builds(app_name)
      revisions = @redis_store.zrange(self.versioned_build_revisions_key(app_name), 0, -1)

      revisions.map do |revision|
        EmberAppVersionedBuild.new(
          redis_key: self.versioned_build_key(app_name, revision),
          redis_store: @redis_store,
          short_commit_sha: revision.split("+").last,
          version: revision.split("+").first
        )
      end
    end

    protected

    def branch_build_key(app_name, branch_name, revision)
      "#{app_name}:branch:#{branch_name}:#{revision}"
    end

    def branch_build_revisions_key(app_name, branch_name)
      "#{app_name}:branch:#{branch_name}:revisions"
    end

    def development_build_key(app_name)
      "#{app_name}:development:__development__"
    end

    def versioned_build_key(app_name, revision)
      "#{app_name}:version:#{revision}"
    end

    def versioned_build_revisions_key(app_name)
      "#{app_name}:version:revisions"
    end
  end
end
