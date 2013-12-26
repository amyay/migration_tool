class User::Agent < User
  has_many :assigned_tickets, class_name: "Ticket", foreign_key: "assignee_id"
end