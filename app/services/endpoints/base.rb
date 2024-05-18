# frozen_string_literal: true

module Endpoints
  # Base service to handle common endpoint functionality
  class Base
    REQUIRED_KEYS = %w[verb path response].freeze

    def initialize(params)
      @params = params
    end

    protected

    attr_reader :params

    def validate_params!
      missing_keys = REQUIRED_KEYS.reject { |key| params.key?(key) }

      return unless missing_keys.any?

      error_message = I18n.t('endpoint.errors.missing_parameters', keys: missing_keys.join(', '))
      raise ActionController::ParameterMissing, error_message
    end

    def endpoint_params
      params.permit(:verb, :path, response: [:code, { headers: {} }, :body])
    end
  end
end
