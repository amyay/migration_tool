class Comment < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  belongs_to :ticket

  validates :author, presence: true
  validates :ticket, presence: true

  # ticket comment can only be private if author is agent
  # validate :validate_public

  # before_validation :ensure_private_comment_is_allowed

  protected
    def validate_public
    end

    def ensure_private_comment_is_allowed
      if !is_public?
        if author.type != 'User::Agent'
          self.is_public = true
        end
      end
    end

    def is_public?
      self.is_public
    end
end