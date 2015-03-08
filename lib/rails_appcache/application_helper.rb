module RailsAppcache
  module ApplicationHelper
    def appcache_manifest_path(path)
      return "" unless RailsAppcache.config.perform_caching?

      "/#{path}-#{appcache_version_string}.appcache"
    end

    # In development, serve up a new manifest every time
    # In production, serve the current Git revision
    def appcache_version_string
      RailsAppcache.config.version
    end

    def stylesheet_cache_path(*paths)
      tags = stylesheet_link_tag(*paths)
      tags.scan(/href="(.*?)"/).map do |match|
        match[0].html_safe
      end.join("\n")
    end

    def javascript_cache_path(*paths)
      tags = javascript_include_tag(*paths)
      tags.scan(/src="(.*?)"/).map do |match|
        match[0].html_safe
      end.join("\n")
    end

    def asset_cache_path(path)
      asset_path(path)
    end
  end
end
