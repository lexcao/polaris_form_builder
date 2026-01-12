# frozen_string_literal: true

class ComponentsController < ApplicationController
  COMPONENT_FIELDS = {
    checkbox: %i[require_a_confirmation_step],
    text_field: %i[store_name],
    number_field: %i[quantity],
    email_field: %i[email],
    password_field: %i[password],
    url_field: %i[your_website],
    search_field: %i[search],
    text_area: %i[shipping_address],
    select: %i[date_range],
    color_field: %i[field],
    date_field: %i[field],
    color_picker: %i[field]
  }.freeze

  before_action :set_component, only: %i[show preview]

  def index
    @components = Component.all
  end

  def show
    @preview = preview_from_params || preview_from_session
  end

  def preview
    session[:preview] = preview_params
    redirect_to @component
  end

  private
    def set_component
      @component = Component.find(params.expect(:name))
    end

    def preview_from_params
      Preview.new(preview_params) if params[:preview]
    end

    def preview_from_session
      return unless session[:preview]

      Preview.new(session.delete(:preview))
    end

    def preview_params
      return {} unless params.key?(:preview)

      params.require(:preview).permit(*permitted_fields)
    end

    def permitted_fields
      component_key = @component.name.to_s.underscore.to_sym
      COMPONENT_FIELDS.fetch(component_key, [])
    end
end
