module RailsEmberRenderer
  module Helper
    # Renders an ember app
    #   render_ember_app(name: "company-frontend")
    def render_ember_app(options = {})
      requested_version = options[:version_range] || params[:ember_app_version]
      requested_branch = options[:branch] || params[:ember_app_branch]
      requested_commit_sha = options[:commit_sha] || params[:ember_app_sha]

      ember_app_constraint = if requested_branch.present? || requested_commit_sha.present? || requested_version.present?
        EmberAppConstraint.new(branch: requested_branch, commit_sha: requested_commit_sha, version_range: requested_version, is_from_request: true)
      elsif RailsEmberRenderer::Configuration.instance.default_ember_app_branch.present?
        EmberAppConstraint.new(branch: RailsEmberRenderer::Configuration.instance.default_ember_app_branch)
      elsif RailsEmberRenderer::Configuration.instance.default_ember_app_version_range.present?
        EmberAppConstraint.new(version_range: RailsEmberRenderer::Configuration.instance.default_ember_app_version_range)
      else
        EmberAppConstraint.new(version_range: "*")
      end

      ember_app_html = EmberAppHTMLBuilder.new.ember_app_html(
        options[:store] || RailsEmberRenderer::Configuration.instance.ember_store,
        options[:name] || RailsEmberRenderer::Configuration.instance.default_ember_app_name,
        ember_app_constraint,
        {}
      )

      render html: ember_app_html
    end
  end
end
