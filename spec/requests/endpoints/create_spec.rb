# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Endpoints#create' do
  let(:endpoint_params) do
    {
      data: {
        attributes: {
          verb: 'GET',
          path: '/hello',
          response: {
            code: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: '{"message":"Hello, world"}'
          }
        }
      }
    }
  end

  context 'with valid parameters' do
    before { post endpoints_path, params: endpoint_params }

    it { expect(response).to have_http_status(:created) }
    it { expect(Endpoint.count).to eq 1 }
    it { expect(json_response['path']).to eq('/hello') }
    it { expect(json_response['verb']).to eq('GET') }
    it { expect(json_response['response']['code']).to eq('200') }
  end

  context 'when required parameters are missing' do
    before do
      endpoint_params[:data][:attributes].delete(:response)

      post endpoints_path, params: endpoint_params
    end

    it { expect(response).to have_http_status(:bad_request) }
    it { expect(Endpoint.count).to eq 0 }
    it { expect(json_response).to include('error') }
  end

  context 'with invalid parameters' do
    before do
      endpoint_params[:data][:attributes][:verb] = 'INVALID'

      post endpoints_path, params: endpoint_params
    end

    it { expect(response).to have_http_status(:bad_request) }
    it { expect(Endpoint.count).to eq 0 }
  end
end
