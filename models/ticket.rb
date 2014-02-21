class Ticket < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :comments
  belongs_to :requester, class_name: "User"
  belongs_to :assignee, class_name: "User"

  # ticket must have a requester
  validates :requester, presence: true
  # ticket description cannot be empty
  validates :description, presence: true

  # make sure status valid
  validate :validate_status
  # make sure assignee must be present when status is solved or closed
  validate :validate_assignee

  before_validation :ensure_requester_is_present, on: :create
  before_validation :ensure_description_is_present, on: :create
  before_validation :ensure_status_is_valid, on: :create
  before_validation :ensure_assignee_is_present, on: :create

  protected
    def validate_status
      if !valid_status?
        errors.add(:status, "invalid status")
      end
    end

    def validate_assignee
      if !assignee_present_for_closed_status?
        errors.add(:assignee, "assignee must be present for solved or closed tickets")
      end
    end


    def ensure_requester_is_present
      if self.requester.nil?
        # puts "aa debug in before_validation: requester is nil(?)"
        # puts self.requester.inspect
        # puts self.inspect
        self.requester = User.find_or_create_by_email 'defaultrequester@migrationscript.com'
        self.requester.name = "Default Requester"
        self.requester.save!
      end
    end

    def ensure_description_is_present
      if description.nil? || description.blank?
        self.description = '(blank)'
      end
    end

    def ensure_status_is_valid
      if !valid_status?
        self.status = 'open'
      end
    end

    def ensure_assignee_is_present
      if !assignee_present_for_closed_status?
        self.assignee = User::Agent.find_or_create_by_email 'defaultagent@migrationscript.com'
        self.assignee.name = "Default Agent"
        self.assignee.save!
      end
    end

    def valid_status?
      valid_statuses = Set.new ['new', 'pending', 'open', 'solved', 'closed']
      return valid_statuses.include? status
    end

    def assignee_present_for_closed_status?
      closed_statuses = Set.new ['solved', 'closed']
      return !((assignee.nil?) && (closed_statuses.include? status))
    end
end
