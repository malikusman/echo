# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Endpoints::UpdateService do
  subject(:service_call) { described_class.new(endpoint, params).call }

  let!(:endpoint) { create(:endpoint, verb: 'GET') }
  let(:params) { ActionController::Parameters.new(input_params) }

  describe '#call' do
    context 'with all required parameters provided' do
      let(:input_params) do
        {
          verb: 'PATCH',
          path: endpoint.path,
          response: {
            code: 200,
            headers: { 'Content-Type': 'application/json' },
            body: 'Updated response'
          }
        }
      end

      it 'successfully updates the endpoint' do
        expect { service_call }.to change { endpoint.reload.verb }.from('GET').to('PATCH')
      end

      it { expect(service_call[:success]).to be true }
      it { expect(service_call[:endpoint]).to be_persisted }
    end

    context 'when required parameters are missing' do
      let(:input_params) { { verb: 'PATCH', path: endpoint.path } } # response is missing from hash

      it { expect { service_call }.to raise_error(ActionController::ParameterMissing) }
    end

    context 'when parameters are invalid' do
      let(:input_params) do
        {
          verb: 'INVALID', # Invalid HTTP verb
          path: endpoint.path,
          response: {
            code: 202,
            headers: { 'Content-Type': 'application/json' },
            body: 'Updated response'
          }
        }
      end

      it { expect { service_call }.not_to change { endpoint.reload.verb } }
      it { expect(service_call[:success]).to be false }
      it { expect(service_call[:errors]).to include(match(/is not included in the list/)) }
    end
  end
end
