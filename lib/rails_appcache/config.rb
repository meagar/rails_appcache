# Simple configuration storage for RailsAppcache

module RailsAppcache

  def self.config
    @config ||= Config.new
  end

  class Config
    # Check whether appcache caching is enabled; default off in development, on elsewhere
    def perform_caching?
      @perform_caching || !Rails.env.development?
    end

    # Turn caching on or off
    def perform_caching=(val)
      @perform_caching = !!val
    end

    # Return the current manifests version string, falling back to the Rails asset version string
    def version
      @appcache_version || Rails.application.config.assets.version
    end

    # Assign an explicit version to our manifests
    def version=(value)
      @appcache_version = value
    end
  end

end

