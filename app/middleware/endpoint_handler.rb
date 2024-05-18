# frozen_string_literal: true

# Middleware to intercept requests and respond accordingly
class EndpointHandler
  ENDPOINT_PATHS = {
    '/endpoints' => %w[GET POST],
    %r{/endpoints/\w+} => %w[PATCH PUT DELETE]
  }.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)

    # Bypass for endpoints requests
    return @app.call(env) if bypass_for_endpoints?(req)

    endpoint = Endpoint.find_by(verb: req.request_method, path: req.path_info)

    if endpoint
      [endpoint.response['code'], endpoint.response['headers'].transform_keys(&:to_s),
       [endpoint.response['body'].to_json]]
    else
      [404, { 'Content-Type' => 'application/vnd.api+json' },
       [{ errors: [{ code: 'not_found', detail: "Requested page `#{req.path_info}` does not exist" }] }.to_json]]
    end
  end

  private

  def bypass_for_endpoints?(request)
    ENDPOINT_PATHS.any? do |path, methods|
      request.path_info.match?(path) && methods.include?(request.request_method)
    end
  end
end
