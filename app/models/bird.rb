class Bird
  include Mongoid::Document
  field :name, type: String
  field :family, type: String
  field :continents, type: Array, default: Array.new
  field :added, type: Time, default: Time.zone.now
  field :visible, type: Mongoid::Boolean, default: false

  index(visible: 1)

  validates_presence_of :name, :family, :continents, :added, :visible
  scope :visible, -> { where(visible: true) }
end
