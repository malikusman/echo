# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Endpoint do
  subject(:endpoint) { build(:endpoint) }

  describe 'validations' do
    let(:valid_path) { '/api/endpoints/' }
    let(:invalid_path) { 'api endpoints' }

    it { is_expected.to validate_presence_of(:id) }
    it { is_expected.to validate_uniqueness_of(:id) }

    it { is_expected.to validate_presence_of(:verb) }
    it { is_expected.to validate_inclusion_of(:verb).in_array(Endpoint::VALID_VERBS) }

    it { is_expected.to validate_presence_of(:path) }
    it { is_expected.to allow_value(valid_path).for(:path) }
    it { is_expected.not_to allow_value(invalid_path).for(:path).with_message(I18n.t('endpoint.errors.valid_uri_path')) }

    it { is_expected.to validate_presence_of(:response) }

    describe 'custom validations' do
      let(:invalid_code) { Faker::Number.between(from: 600, to: 1000)} # valid are between 100 to 599

      let(:response_with_invalid_code) { { code: invalid_code, headers: {}, body: Faker::Lorem.sentence } }
      let(:response_with_non_hash_headers) { { code: 200, headers: Faker::Lorem.sentence, body: Faker::Lorem.sentence } }
      let(:response_with_non_string_body) { { code: 200, headers: {}, body: Faker::Number.number } }
      let(:response_missing_code) { { headers: {}, body: Faker::Lorem.sentence } }

      context 'when response is nil' do
        before { endpoint.response = nil }

        it 'validates response is not nil and must be a hash' do
          endpoint.valid?
          expect(endpoint.errors[:response]).to include(I18n.t('endpoint.errors.must_be_hash'))
        end
      end

      context 'when response code is missing' do
        before { endpoint.response = response_missing_code }

        it 'adds an error for missing code' do
          endpoint.valid?
          expect(endpoint.errors[:response]).to include(I18n.t('endpoint.errors.must_contain_code'))
        end
      end

      context 'when response code is invalid' do
        before { endpoint.response = response_with_invalid_code }

        it 'adds an error for invalid code' do
          endpoint.valid?
          expect(endpoint.errors[:response]).to include(I18n.t('endpoint.errors.must_contain_valid_code'))
        end
      end

      context 'when response headers are not a hash' do
        before { endpoint.response = response_with_non_hash_headers }

        it 'adds an error for invalid headers format' do
          endpoint.valid?
          expect(endpoint.errors[:response]).to include(I18n.t('endpoint.errors.headers_must_be_hash'))
        end
      end

      context 'when response body is not a string' do
        before { endpoint.response = response_with_non_string_body }

        it 'adds an error for invalid body format' do
          endpoint.valid?
          expect(endpoint.errors[:response]).to include(I18n.t('endpoint.errors.body_must_be_string'))
        end
      end
    end

    context 'when another endpoint exists with the same verb and path' do
      subject(:endpoint) { build(:endpoint, verb: 'GET', path: '/rand') }

      before do
        create(:endpoint, verb: 'GET', path: '/rand')
      end

      it 'is invalid due to non-unique verb and path combination' do
        expect(endpoint).not_to be_valid
        expect(endpoint.errors[:verb]).to include(I18n.t('endpoint.errors.unique_verb_path'))
      end
    end
  end
end
