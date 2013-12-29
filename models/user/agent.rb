class User::Agent < User
  has_many :assigned_tickets, class_name: "Ticket", foreign_key: "assignee_id"
  has_and_belongs_to_many :groups
end