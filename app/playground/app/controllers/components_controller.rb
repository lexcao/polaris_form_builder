class ComponentsController < ApplicationController
  before_action :set_component, only: %i[ show ]

  # GET /components
  def index
    @components = Component.all
  end

  # GET /components/{name}
  def show
  end

  # POST /components
  def create
    # TODO: render params back
    puts params
    redirect_to @component
  end

  private

  def set_component
    @component = Component.find(params.expect(:name))
  end

end
