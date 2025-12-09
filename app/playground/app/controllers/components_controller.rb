class ComponentsController < ApplicationController
  before_action :set_component, only: %i[ show preview ]

  # GET /components
  def index
    @components = Component.all
  end

  # GET /components/{name}
  def show
    @preview = get_preview
  end

  # POST /components/{name}/preview
  def preview
    set_preview
    redirect_to @component
  end

  private

  def set_component
    @component = Component.find(params.expect(:name))
  end

  def get_preview
    get_preview_from_params || get_preview_from_session
  end

  def get_preview_from_params
    Preview.new preview_params if params[:preview]
  end

  def get_preview_from_session
    params = session[:preview]
    if params
      session.delete :preview
      Preview.new params
    end
  end

  def set_preview
    session[:preview] = preview_params
  end

  def preview_params
    params.expect(preview: [ :store_name ])
  end

end
