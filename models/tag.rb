class Tag < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :tickets

  validates :name, uniqueness: { case_sensitive: false }

  before_save { |tag| tag.name.downcase! }
end