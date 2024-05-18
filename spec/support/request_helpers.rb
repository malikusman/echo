# frozen_string_literal: true

# Custom helpers for request tests.
module RequestHelpers
  def json_response
    @json_response ||= JSON.parse response.body
  end
end
