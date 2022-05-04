# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  mount Sidekiq::Web => '/jobs'
  root 'home#index'
  resource :spends
end
