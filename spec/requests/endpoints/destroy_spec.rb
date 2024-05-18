# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Endpoints#destroy' do
  let!(:endpoint) { create(:endpoint) }

  context 'when the endpoint exists' do
    before { delete endpoint_path(endpoint) }

    it { expect(Endpoint.exists?(endpoint.id)).to be false }
    it { expect(response).to have_http_status(:no_content) }
  end

  context 'when the endpoint does not exist' do
    before { delete endpoint_path('non-existent-id') }

    it { expect(response).to have_http_status(:not_found) }
  end
end
