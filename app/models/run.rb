require 'autoinc'

class Run
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  field :no, type: Integer
  field :runner, type: String
  field :running_time, type: Integer # Minutes
  field :cups, type: Integer
  field :expired_at, type: Time, default: Time.now

  increments :no

  # Relations
  embeds_many :orderers

  # Validations
  validates :runner, presence: true
  validates :running_time, presence: true, :numericality => { :greater_than => 0 , :less_than_or_equal_to => 60 }
  validates :cups, presence: true, :numericality => { :greater_than => 0, :less_than_or_equal_to => 20 }
  # TODO: validate meaningful runner name

  # Scope
  scope :find_by_no, ->(no) { where(:no => no)}
end
