# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Endpoints#update' do
  let!(:endpoint) { create(:endpoint, verb: 'GET', path: '/hello', response: response_data) }

  let(:response_data) do
    { code: 200, headers: { 'Content-Type' => 'application/json' }, body: 'Hello, world' }
  end

  let(:update_params) do
    {
      data: {
        attributes: {
          verb: 'PATCH',
          path: '/hello',
          response: {
            code: 202,
            headers: { 'Content-Type' => 'application/json' },
            body: '{"message":"Updated body!"}'
          }
        }
      }
    }
  end

  context 'with valid parameters' do
    before { patch endpoint_path(endpoint), params: update_params }

    it { expect(response).to have_http_status(:ok) }
    it { expect(Endpoint.find(endpoint.id).verb).to eq('PATCH') }
    it { expect(Endpoint.find(endpoint.id).response['body']).to include('Updated body!') }
  end

  context 'with missing parameters' do
    before do
      update_params[:data][:attributes].delete(:response)

      patch endpoint_path(endpoint), params: update_params
    end

    it { expect(response).to have_http_status(:bad_request) }
    it { expect(json_response).to include('error') }
  end

  context 'with invalid parameters' do
    before do
      update_params[:data][:attributes][:verb] = 'INVALID'

      patch endpoint_path(endpoint), params: update_params
    end

    it { expect(response).to have_http_status(:unprocessable_entity) }
    it { expect(json_response['errors']).to include(match(/is not included in the list/)) }
  end
end
