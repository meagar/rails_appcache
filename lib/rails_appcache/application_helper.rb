module RailsAppcache
  module ApplicationHelper
    def appcache_manifest_path(path)
      "/#{path}.appcache"
    end

    # In development, serve up a new manifest every time
    # In production, serve the current Git revision
    def appcache_version_string
      if Rails.env.development?
        Time.now.to_i.to_s
      else
        # Use the REVISION file left in root from capistrano
        if File.exists?(Rails.root.join('REVISION'))
          File.read(Rails.root.join('REVISION'))
        else
          `git rev-parse HEAD`
        end
      end
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
