require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'schema' do
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:password_digest).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:username).of_type(:string) }
    it { should have_db_index(:email) }
    it { should have_db_index(:username) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_length_of(:username) }
    it { is_expected.to validate_length_of(:password) }
  end

end
