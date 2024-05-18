# frozen_string_literal: true

module Endpoints
  # Validating and creating endpoint.
  class CreateService < Base
    def call
      validate_params!

      endpoint = Endpoint.new(endpoint_params)

      if endpoint.save
        { success: true, endpoint: }
      else
        { success: false, errors: endpoint.errors.full_messages }
      end
    end
  end
end
