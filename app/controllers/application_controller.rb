class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Helper
  include ApplicationHelper

  # Call back
  before_action :authorize

  private

  def authorize
    session[:authorize_token] = session[:authorize_token] || Digest::SHA1.hexdigest([Time.now, rand].join)
    logger.debug("Authorize token = #{session[:authorize_token]}")
  end
end
