class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  INVALID_PASSWORD_REGEX = /password/

  validates(:name, presence: true, length: { maximum: 50 })
  validates(:email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false })

  validates(:password, presence: true, length: { minimum: 8 }, format: { without: INVALID_PASSWORD_REGEX })

  has_secure_password
end
