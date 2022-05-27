module RailsEmberRenderer
  class EmberAppHTMLBuilder
    def ember_app_html(ember_app_store, ember_app_name, ember_app_constraint, options = {})
      build = self.find_build(ember_app_store, ember_app_name, ember_app_constraint)

      unless build&.index_html
        raise RailsEmberRenderer::BuildNotFoundError, <<~ERROR
          No build found for ember app #{ember_app_name} #{build ? "(redis_key: #{build.redis_key})" : ''}

          #{ember_app_constraint.version_range.present? ? "required_version: #{ember_app_constraint.version_range}" : ''}
          #{ember_app_constraint.branch.present? ? "required_branch: #{ember_app_constraint.branch}" : ''}
          #{ember_app_constraint.commit_sha.present? ? "required_branch: #{ember_app_constraint.commit_sha}" : ''}
        ERROR
      end

      build.index_html
    end

    protected

    def find_build(ember_app_store, ember_app_name, ember_app_constraint)
      # If parameters were passed in the request, don't look for local builds
      unless ember_app_constraint.from_request?
        development_build = ember_app_store.get_development_build(ember_app_name)

        return development_build if development_build
      end

      if ember_app_constraint.branch.present?
        # For branch builds, we don't have a way to know which build is the "latest".
        # We use 'reverse' here so that we return the one that was deployed last.
        ember_app_store
          .get_branch_builds(ember_app_name, ember_app_constraint.branch)
          .reverse
          .detect { |build| ember_app_constraint.satisfied_by?(build) }
      else
        ember_app_store
          .get_versioned_builds(ember_app_name)
          .sort_by(&:semver_version)
          .detect { |build| ember_app_constraint.satisfied_by?(build) }
      end
    end
  end
end
