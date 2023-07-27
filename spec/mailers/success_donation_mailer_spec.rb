# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuccessDonationMailer, type: :mailer do
  describe 'success_mail' do
    let(:user) { create :user, email: 'carlosdgild@gmail.com' }
    let(:donation) { create :donation, user: user }

    it 'sends successfull email in background job' do
      result = described_class.success_mail(donation).deliver_now

      expect(result.subject).to eq('Thank you for your donation!')
      expect(result.from).to eq(['donation.api.carlos.gil@gmail.com'])
      expect(result.to.last).to eq(user.email)
    end
  end
end
