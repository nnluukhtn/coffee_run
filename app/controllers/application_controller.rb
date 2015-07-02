class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Helper
  include ApplicationHelper

  # Call back
  before_action :authorize
  around_action :set_time_zone

  # Rescue exception
  rescue_from Exception do |e|
    if e.kind_of?(CoffeeRunError)
      render json: e.to_json, status: 400
    else
      if is_api_format
        render :json => {:error => "Unexpected server error"}, :status => 500
        logger.error "Fault: #{e.to_s}\n#{e.backtrace.join("\n")}"
      else
        raise e
      end
    end

  end

  private

  def authorize
    session[:authorize_token] = session[:authorize_token] || Digest::SHA1.hexdigest([Time.now, rand].join)
    session[:ordered] = session[:ordered] || "false"
  end

  def set_time_zone
    return yield unless (utc_offset = cookies["browser.tzoffset"]).present?
    utc_offset = utc_offset.to_i
    gmt_offset = if utc_offset == 0 then nil elsif utc_offset > 0 then -utc_offset else "+#{-utc_offset}" end
    Time.use_zone("Etc/GMT#{gmt_offset}"){ yield }
  rescue ArgumentError
    yield
  end
end
