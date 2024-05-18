# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointHandler, type: :middleware do
  let(:app) { EndpointHandler.new(->(env) { [200, { 'Content-Type' => 'application/json' }, ['{"success":true}']] }) }

  describe 'handling requests' do
    context 'when the path is not registered' do
      let(:error_message) do
        {
          'errors' => [
            {
              'code' => 'not_found',
              'detail' => 'Requested page `/hello` does not exist'
            }
          ]
        }
      end

      before { get '/hello' }

      it { expect(last_response.status).to eq(404) }
      it { expect(last_response.headers['Content-Type']).to eq('application/vnd.api+json') }

      it 'returns the custom not found JSON' do
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body).to eq(error_message)
      end
    end

    context 'when the path is registered' do
      let!(:endpoint) { create(:endpoint, verb: 'GET', path: '/hello', response: { code: 200, headers: { 'Content-Type' => 'application/json' }, body: 'hello world' }) }

      before { get '/hello' }

      it { expect(last_response.status).to eq(200) }
      it { expect(last_response.headers['Content-Type']).to include('application/json') }
      it { expect(last_response.body).to include('hello world') }
    end

    context 'when accessing endpoint paths' do
      before { get '/endpoints' }

      it { expect(last_response.status).to eq(200) }
      it { expect(last_response.body).to include('success') }
    end
  end
end
