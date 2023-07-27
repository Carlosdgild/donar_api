require 'rails_helper'

describe NotifyErrorChargeJob, type: :job do
  let!(:user) { create :user, email: 'carlosdgild@gmail.com'}
  let!(:donation) { create :donation, user: user }

  it "enqueues a job" do
    expect do
      NotifyErrorChargeJob.perform_async(donation)
    end.to change(NotifyErrorChargeJob.jobs, :size).by(1)
  end

  it "Performs a job and sends email" do
    Sidekiq::Testing.inline! do
      NotifyErrorChargeJob.perform_async(donation.id)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.last.to).to include(donation.user.email)
    end
  end
end
