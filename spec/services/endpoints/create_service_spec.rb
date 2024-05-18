# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Endpoints::CreateService do
  subject(:service_call) { described_class.new(params).call }

  let(:params) { ActionController::Parameters.new(input_params) }

  describe '#call' do
    context 'with all required parameters provided' do
      let(:input_params) do
        {
          verb: 'GET',
          path: '/hello',
          response: {
            code: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: 'Hello, world!'
          }
        }
      end

      it { expect { service_call }.to change(Endpoint, :count).by(1) }
      it { expect(service_call[:success]).to be true }
      it { expect(service_call[:endpoint]).to be_persisted }
    end

    context 'when required parameters are missing' do
      let(:input_params) { { verb: 'GET', path: '/hello' } } # response is missing from hash

      it { expect { service_call }.to raise_error(ActionController::ParameterMissing) }
    end

    context 'when parameters are invalid' do
      let(:input_params) do
        {
          verb: 'INVALID', # Invalid HTTP verb
          path: '/hello',
          response: {
            code: 200,
            headers: { 'Content-Type' => 'application/json' },
            body: 'Hello, world!'
          }
        }
      end

      it { expect { service_call }.not_to change(Endpoint, :count) }
      it { expect(service_call[:success]).to be false }
      it { expect(service_call[:errors]).to include(match(/is not included in the list/)) }
    end
  end
end
