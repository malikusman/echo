# frozen_string_literal: true

module Endpoints
  # Validating and updating endpoint.
  class UpdateService < Base
    def initialize(endpoint, params)
      super(params)
      @endpoint = endpoint
    end

    def call
      validate_params!

      if endpoint.update(endpoint_params)
        { success: true, endpoint: }
      else
        { success: false, errors: endpoint.errors.full_messages }
      end
    end

    private

    attr_reader :endpoint
  end
end
