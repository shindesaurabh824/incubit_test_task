class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :username, length: { minimum: Constant::USERNAME_MIN_LENGTH },
                       format: { with: Constant::USERNAME_REGEX },
                       on: :update, if: :username_changed?

  validates :password, presence: true,
                       length: { minimum: Constant::PASSWORD_MIN_LENGTH }, if: :password_digest_changed?
end
