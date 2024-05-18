# frozen_string_literal: true

require 'rack/test'

module MiddlewareHelpers
  include Rack::Test::Methods

  def app
    # Define your default Rack app, if one is necessary, or ensure each test defines its own
    Rails.application
  end
end
