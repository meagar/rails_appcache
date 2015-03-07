
class RailsAppcache::ManifestsController < RailsAppcache::ApplicationController
  def show
    render params[:manifest]
  end
end
