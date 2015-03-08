require 'rails_appcache/engine'
require 'rails_appcache/application_helper'
require 'rails_appcache/config'

module RailsAppcache
end

Mime::Type.register 'text/appcache', :appcache

ActiveSupport.on_load(:action_view) do
  include RailsAppcache::ApplicationHelper
end
