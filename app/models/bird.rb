class Bird
  include Mongoid::Document
  field :name, type: String
  ## To avoid redundancy and for faster filtering 'family' and 'continents' can be moved to separate documents
  field :family, type: String
  field :continents, type: Array, default: Array.new
  field :added, type: Time, default: Time.zone.now
  field :visible, type: Mongoid::Boolean, default: false

  index(visible: 1)

  validates_presence_of :name, :family, :continents, :added, :visible
  scope :visible, -> { where(visible: true) }
  before_create :filter_duplicate_continents

  private
    def filter_duplicate_continents
      self.continents = continents.uniq
    end
end
