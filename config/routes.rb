RailsAppcache::Engine.routes.draw do
  get ':manifest.appcache' => 'manifests#show', format: 'appcache'
end
