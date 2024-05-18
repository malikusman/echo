# frozen_string_literal: true

# Manages endpoints for the mock server.
class EndpointsController < ApplicationController
  before_action :set_endpoint, only: %i[update destroy]

  def index
    render json: Endpoint.all
  end

  def create
    result = Endpoints::CreateService.new(endpoint_params).call

    if result[:success]
      render json: result[:endpoint], status: :created
    else
      render json: { error: result[:error] }, status: :bad_request
    end
  end

  def update
    result = Endpoints::UpdateService.new(endpoint, endpoint_params).call
    if result[:success]
      render json: result[:endpoint]
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    endpoint.destroy

    head :no_content
  end

  private

  attr_reader :endpoint

  def set_endpoint
    @endpoint = Endpoint.find(params[:id])
  end

  def endpoint_params
    params.require(:data)
          .require(:attributes)
          .permit(:verb, :path, response: [:code, { headers: {} }, :body])
  end
end
