# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Endpoints#index' do
  context 'when endpoints are present' do
    let!(:endpoints) { create_list(:endpoint, 3) }

    before { get endpoints_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response.size).to eq(3) }
    it { expect(json_response).to all(be_a(Hash)) }
    it { expect(json_response).to all(include('id', 'verb', 'path', 'response')) }
    it { json_response.each { |endpoint| expect(endpoint['response']).to include('code', 'headers', 'body') } }
  end

  context 'when no endpoints exist' do
    before { get endpoints_path }

    it { expect(response).to have_http_status(:ok) }
    it { expect(json_response).to eq([]) }
  end
end
