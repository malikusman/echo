# frozen_string_literal: true

FactoryBot.define do
  factory :endpoint do
    verb { %w[GET POST PUT PATCH DELETE].sample }
    path { "/#{Faker::Internet.slug}" }
    response do
      {
        code: Faker::Number.between(from: 100, to: 599),
        headers: { 'Content-Type' => 'application/json' },
        body: Faker::Lorem.sentence
      }
    end
  end
end
