require 'sidekiq/web'
Rails.application.routes.draw do

  # Run
  post "runs/create", to: "runs#create", format: :json
  get "runs/show", to: "runs#show"
  get "runs/runned_list", to: "runs#runned_list"
  get "runs/running_list", to: "runs#running_list"
  post "runs/submit", to: "runs#submit"

  # Pusher
  post "pusher/auth", to: "pusher#auth"

  # Sidekiq admin
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if (Rails.env.production?)
  mount Sidekiq::Web, at: "/sidekiq"

  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]

end
