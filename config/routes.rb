# frozen_string_literal: true
require "sidekiq/web"
# https://github.com/ondrejbartas/sidekiq-cron#web-ui-for-cron-jobs
require "sidekiq/cron/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  mount RedisDashboard::Application, at: "redis"


	devise_for :users, controllers: { registrations: "registrations" }
	resources :donations, only: %i[index create destroy update]
end
