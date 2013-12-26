class User < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :requested_tickets, class_name: "Ticket", foreign_key: "requester_id"
end