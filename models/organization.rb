class Organization < ActiveRecord::Base
  has_and_belongs_to_many :users, class_name: "User"

  # organization must have a name
  validates :name, presence: true
end