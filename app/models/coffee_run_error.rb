class CoffeeRunError < RuntimeError 
  def initialize(message)
    super(message)
    @message = message
  end
  
  def to_json
    { "ok" => false, "error" => @message }.to_json
  end
end
