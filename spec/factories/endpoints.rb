# frozen_string_literal: true

# spec/factories/endpoints.rb
FactoryBot.define do
  factory :endpoint do
    id { SecureRandom.uuid }
    verb { %w[GET POST PUT PATCH DELETE].sample }
    path { Faker::Internet.slug }
    response do
      {
        code: Faker::Number.between(from: 100, to: 599),
        headers: { 'Content-Type' => 'application/json' },
        body: Faker::Lorem.sentence
      }
    end
  end
end
