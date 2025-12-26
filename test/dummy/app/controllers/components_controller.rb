# frozen_string_literal: true

class ComponentsController < ApplicationController
  before_action :require_loader
  before_action :load_component
  before_action :load_example
  before_action :build_preview

  helper_method :submit_label

  def show; end

  def submit
    if @preview.valid?
      redirect_to component_path(@component, preview: preview_params), notice: "Preview saved.", status: :see_other
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def require_loader
    require Rails.root.join("..", "..", "data", "loader").expand_path.to_s
  end

  def load_component
    @component = params.fetch(:component)
  end

  def load_example
    @example = ComponentExampleLoader.load(component_key, name: "Main example")
  rescue ComponentExampleLoader::ExampleNotFound => e
    raise ActionController::RoutingError, e.message
  end

  def build_preview
    @preview = PreviewForm.new(preview_params.merge(component_key: component_key))
  end

  def preview_params
    return {} unless params.key?(:preview)

    params.require(:preview).permit(*component_fields)
  end

  def component_fields
    {
      checkbox: %i[require_a_confirmation_step],
      text_field: %i[store_name],
      number_field: %i[quantity],
      email_field: %i[email],
      password_field: %i[password],
      url_field: %i[your_website],
      search_field: %i[search],
      text_area: %i[shipping_address]
    }.fetch(component_key) do
      raise ActionController::RoutingError, "Unknown component #{component_key}"
    end
  end

  def component_class_name
    @component_class_name ||= @component.to_s.camelize
  end

  def component_key
    @component_key ||= @component.to_s.underscore.to_sym
  end

  def submit_label
    "Save #{component_class_name.titleize}"
  end
end
