
class AppcacheManifestGenerator < Rails::Generators::NamedBase
  def create_appcache_manifest
    create_file "app/views/rails_appcache/manifests/#{file_name}.appcache.erb", <<-FILE 
CACHE MANIFEST

# auto-expire appcache in dev
# <%= appcache_version_string %>

CACHE:
# by default, only the root path is cached
/

# Cache additional paths by using path helpers:
# <%= posts_path %>

# Cache our JS/CSS bundles
<%= stylesheet_cache_path '#{file_name}' %>
<%= javascript_cache_path '#{file_name}' %>

# Cache additional assets by using the asset_cache_path, or any of the Rails built-in asset pipeline helpers
# <%= asset_cache_path 'logo.png' %>
# or
# <%= asset_path 'logo.png' %>

# Make everything else accessible
# WITHOUT THIS LINE, your browser will 404 for anything not explicitly listed under CACHE:
NETWORK:
*
FILE
  end
end
