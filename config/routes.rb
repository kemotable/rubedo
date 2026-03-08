# frozen_string_literal: true

Rails.application.routes.draw do
  # Health check endpoint used by uptime monitors, load balancers and containers.
  # Returns 200 if the app booted successfully, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Root route will be defined once the first UI controller is introduced.
  # root "dashboard#index"
end
