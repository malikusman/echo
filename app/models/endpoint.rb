# frozen_string_literal: true

# The Endpoint model represents a mock API endpoint (defined by the user).
class Endpoint < ApplicationRecord
  include EndpointValidation

  VALID_VERBS = %w[GET POST PUT PATCH DELETE].freeze
  VALID_PATH_REGEX = %r{\A/[a-zA-Z0-9_/-]*\z}

  validates :id, presence: true, uniqueness: true
  validates :verb, presence: true, inclusion: { in: VALID_VERBS }
  validates :path, presence: true, format: { with: VALID_PATH_REGEX, message: I18n.t('endpoint.errors.valid_uri_path') }
  validates :response, presence: true

  # Ensure that the combination of :verb and :path is unique
  validates :verb, uniqueness: { scope: :path, message: I18n.t('endpoint.errors.unique_verb_path') }
end
