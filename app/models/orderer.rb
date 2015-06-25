class Orderer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :beverage, type: String

  # Relations
  embedded_in :run

  # Validations
  validates :name, presence: true
  validates :beverage, presence: true
  # TODO: Validate meaningful name and beverage
  
end
