# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorDonationMailer, type: :mailer do
  describe 'error_mail' do
    let(:user) { create :user, email: 'carlosdgild@gmail.com' }
    let(:donation) { create :donation, user: user }

    it 'sends error email in background job' do
      result = described_class.error_mail(donation).deliver_now

      expect(result.subject).to eq('Error in your donation')
      expect(result.from).to eq(['donation.api.carlos.gil@gmail.com'])
      expect(result.to.last).to eq(user.email)
    end
  end
end
