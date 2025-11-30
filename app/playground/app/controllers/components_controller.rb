class ComponentsController < ApplicationController
  before_action :set_component, only: %i[ show edit update destroy ]

  # GET /components
  def index
    @components = Component.all
  end

  # GET /components/1
  def show
  end

  # GET /components/new
  def new
    @component = Component.new
  end

  # GET /components/1/edit
  def edit
  end

  # POST /components
  def create
    @component = Component.new(component_params)

    if @component.save
      redirect_to @component, notice: "Component was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /components/1
  def update
    if @component.update(component_params)
      redirect_to @component, notice: "Component was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /components/1
  def destroy
    @component.destroy!
    redirect_to components_path, notice: "Component was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component
      @component = Component.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def component_params
      params.fetch(:component, {})
    end
end
