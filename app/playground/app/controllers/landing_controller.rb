# frozen_string_literal: true

class LandingController < ApplicationController
  def show
    @preview = preview_from_session
  end

  def preview
    session[:landing_preview] = preview_params
    redirect_to root_path
  end

  private
    def preview_from_session
      return unless session[:landing_preview]

      LandingPreview.new(session.delete(:landing_preview))
    end

    def preview_params
      params.require(:landing_preview).permit(:title, :description, :status, :featured)
    end
end
