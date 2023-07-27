# frozen_string_literal: true

require 'rails_helper'

describe NotifyErrorChargeJob, type: :job do
  let!(:user) { create :user, email: 'carlosdgild@gmail.com' }
  let!(:donation) { create :donation, user: user }

  it 'enqueues a job' do
    expect do
      described_class.perform_async(donation)
    end.to change(described_class.jobs, :size).by(1)
  end

  it 'Performs a job and sends email' do
    Sidekiq::Testing.inline! do
      described_class.perform_async(donation.id)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.to).to include(donation.user.email)
    end
  end
end
