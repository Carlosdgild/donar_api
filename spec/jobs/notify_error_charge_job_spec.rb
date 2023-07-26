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
    # Set the Sidekiq testing mode to inline
    Sidekiq::Testing.inline! do
      # Perform the action that enqueues NotifyErrorChargeJob
      NotifyErrorChargeJob.perform_async(donation.id)


      # You can also assert the job count directly
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end
