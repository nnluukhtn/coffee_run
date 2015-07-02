class PusherController < ApplicationController

  # Call back
  skip_before_action :verify_authenticity_token

  # Auth for presence channel
  def auth
    if session[:authorize_token]
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        :user_id => session[:authorize_token], # => required
        :user_info => {}
      })
      render :json => response
    else
      render :text => "Forbidden", :status => '403'
    end
  end

end
