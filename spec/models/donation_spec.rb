# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Donation, type: :model do
  subject(:donation) { create(:donation) }

  describe "validations" do
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe "associations" do
    it do
      expect(donation).to belong_to(:user)
      expect(donation).to belong_to(:login_activity)
      expect(donation).to belong_to(:payment).optional
    end
  end

  describe 'paranoid gem' do
    it 'does not find the field deleted_at in donation' do
      expect(donation.deleted_at).to be_nil
      expect(donation).not_to be_deleted
    end

    it 'finds "deleted_at" after deletion' do
      donation.destroy
      expect(donation.deleted_at).to be_present
      expect(donation).to be_deleted
    end

    it 'does not find "deleted_at" after it has been restored' do
      donation.destroy
      expect(donation.deleted_at).to be_present
      expect(donation).to be_deleted
      donation.restore
      expect(donation.deleted_at).to be_nil
      expect(donation).not_to be_deleted
    end
  end
end
