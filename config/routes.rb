Rails.application.routes.draw do
  root :to => "runs#show"

  # Run
  post 'runs/create' => "runs#create", format: :json

end
