class Comment < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :ticket

  validates :author, presence: true
  validates :ticket, presence: true
  validates :is_public, :inclusion => {:in => [true, false]}

  # ticket comment can only be private if author is agent
  # validate :validate_public

  # before_validation :ensure_private_comment_is_allowed, on: :create
  # before_validation :ensure_author_is_present, on: :create

  before_validation :ensure_body_is_present

  protected
    def validate_public
      if !is_public?
        if self.author.type != 'User::Agent'
          errors.add(:is_public, "end user authors not allowed to make private comments")
        end
      end
    end

    def ensure_private_comment_is_allowed
      if !is_public?
        if self.author.type != 'User::Agent'
          # if author is not agent
          # force comment to be public
          self.is_public = true
        end
      end
    end

    def ensure_author_is_present
      if self.author.nil?
        self.author = User::Agent.find_or_create_by_email 'defaultauthor@legacyuser-tripadvisor.com'
        self.author.name = "Default Author"
        self.author.save!
      end
    end

    def is_public?
      self.is_public
    end

    def ensure_body_is_present
      if body.nil? || body.blank?
        self.body = '(blank)'
      end
    end
end