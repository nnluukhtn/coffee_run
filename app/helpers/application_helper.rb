module ApplicationHelper
	def is_api_format
    request.format.json? || request.content_type == "application/json"
  end

  def validate_api_format
    raise CoffeeRunError.new("Invalid request format") if !is_api_format
  end
end
