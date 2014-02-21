class User < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :requested_tickets, class_name: "Ticket", foreign_key: "requester_id"
  has_many :comments, foreign_key: 'author_id'

  def name= name
    super
    self.shortname = (Formatter::Shortname.new self.name).formatted
  end
end