# frozen_string_literal: true

# Keeps shared controllers methods
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_json
  rescue_from ActionController::ParameterMissing, with: :render_400_json

  private

  def render_404_json
    render json: { error: I18n.t('endpoint.errors.endpoint_not_fount') }, status: :not_found
  end

  def render_400_json
    render json: { error: I18n.t('endpoint.errors.endpoint_missing_parameters') }, status: :bad_request
  end
end
