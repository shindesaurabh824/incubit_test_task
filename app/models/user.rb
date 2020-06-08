class User < ApplicationRecord
  has_secure_password

  before_create :set_username
  after_create :send_welcome_email

  validates :email, uniqueness: true, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :username, length: { minimum: Constant::USERNAME_MIN_LENGTH },
                       format: { with: Constant::USERNAME_REGEX },
                       on: :update, if: :username_changed?

  validates :password, presence: true,
                       length: { minimum: Constant::PASSWORD_MIN_LENGTH }, if: :password_digest_changed?

  def send_welcome_email
    EmailWorker.perform_async(:welcome_user, email, :deliver_later)
  end

  private

  def set_username
    self.username = email.split('@').first
  end
end
