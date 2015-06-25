require 'autoinc'

class Run
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  field :no, type: Integer
  field :runner, type: String
  field :running_time, type: DateTime
  field :cups, type: Integer

  increments :no

  # Relations
  embeds_many :orderers
  
  # Validations
  validates :runner, presence: true
  validates :running_time, presence: true
  validates :cups, presence: true, :numericality => { :greater_than => 0 }
  # TODO: validate meaningful runner name
  
  # Scope

end
