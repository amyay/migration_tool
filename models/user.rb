class User < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :requested_tickets, class_name: "Ticket", foreign_key: "requester_id"
  has_many :comments, foreign_key: 'author_id'

  # user must have a name
  validates :name, presence: true

  # user must have valid email address
  validates :email, uniqueness: true
  validate :validate_email

  before_validation :ensure_email_is_valid, on: :create

  def name= name
    super
    self.shortname = (Formatter::Shortname.new self.name).formatted
  end

  protected
    def validate_email
      if !valid_email?
        errors.add(:email, "invalid email address: #{self.email}")
      end
    end

    def ensure_email_is_valid
      if !valid_email?
        if self.email.include? '@'
          # hack away and adjust email as needed
          # for medidata, its' the "=" in the emails
          temp_email = self.email.split '@'
          temp_email[0].gsub! '=', '-'
          self.email = temp_email[0] + '@'+ temp_email[1]
        end
      end
    end

    def valid_email?
      return !(self.email =~ /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i).nil?
    end
end