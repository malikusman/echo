# frozen_string_literal: true

# Endpoint validations, especially dealing with response
module EndpointValidation
  extend ActiveSupport::Concern

  VALID_CODES = (100..599).to_a.freeze

  included do
    validate :response_must_be_hash
    validate :validate_response_code
    validate :validate_response_headers
    validate :validate_response_body
  end

  private

  def response_must_be_hash
    return if response.is_a?(Hash)

    errors.add(:response, I18n.t('endpoint.errors.must_be_hash'))
  end

  def validate_response_code
    if response.blank? || response['code'].blank?
      errors.add(:response, I18n.t('endpoint.errors.must_contain_code'))
    elsif VALID_CODES.exclude?(response['code'].to_i)
      errors.add(:response, I18n.t('endpoint.errors.must_contain_valid_code'))
    end
  end

  def validate_response_headers
    return unless response&.key?('headers')

    if response['headers'].is_a?(Hash)
      validate_header_pairs(response['headers'])
    else
      errors.add(:response, I18n.t('endpoint.errors.headers_must_be_hash'))
    end
  end

  def validate_header_pairs(headers)
    headers.each do |key, value|
      unless key.is_a?(String) && value.is_a?(String)
        errors.add(:response, I18n.t('endpoint.errors.headers_only_string_keys_values'))
      end
    end
  end

  def validate_response_body
    return unless response_body_present_and_not_string

    errors.add(:response, I18n.t('endpoint.errors.body_must_be_string'))
  end

  def response_body_present_and_not_string
    response.present? && response['body'].present? && !response['body'].is_a?(String)
  end
end
