require 'rails_helper'
require 'faker'

RSpec.describe User, type: :model do
  let(:user) { Fabricate(:user) }

  describe 'schema' do
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:password_digest).of_type(:string) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:username).of_type(:string) }
    it { should have_db_index(:email) }
    it { should have_db_index(:username) }
  end

  describe '#create' do
    it { expect { user.save }.to change(User, :count).by(1) }

    it 'should set default username' do
      expect { user.save }.to change(User, :count).by(1)
      expect(user.username).to eq(user.email.split('@').first)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to validate_length_of(:username) }
    it { is_expected.to validate_length_of(:password) }
  end

  describe 'callbacks' do
    it 'should call callback after create' do
      expect(user).to callback(:send_welcome_email).after(:create)
    end

    it 'should call callback before create' do
      expect(user).to callback(:set_username).before(:create)
    end
  end
end
