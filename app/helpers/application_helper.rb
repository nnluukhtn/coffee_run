module ApplicationHelper
	def validate_api_format
    request.format.json? || request.content_type == "application/json"
  end
end
