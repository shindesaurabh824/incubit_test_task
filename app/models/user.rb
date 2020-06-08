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

  def create_reset_password_token
    update(reset_password_token: token, reset_password_sent_at: Time.zone.now)
  end

  def send_reset_password_email
    EmailWorker.perform_async(:reset_password, email, :deliver_later)
  end

  def reset_password_token_expired?
    reset_password_sent_at < Constant::RESET_TOKEN_EXPIRES_IN.hours.ago
  end

  def authenticate?(password)
    authenticate(password)
  end

  private

  def set_username
    self.username = email.split('@').first
  end

  def token
    loop do
      generated_token = SecureRandom.urlsafe_base64
      return generated_token unless User.exists?(reset_password_token: generated_token)
    end
  end
end
