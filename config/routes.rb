# frozen_string_literal: true

Rails.application.routes.draw do
  root to: proc { [404, {}, ['']] }

  defaults format: :json do
    resources :endpoints, only: %i[index create update destroy]
  end
end
