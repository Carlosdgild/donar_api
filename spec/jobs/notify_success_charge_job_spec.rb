require 'rails_helper'

describe NotifySuccessChargeJob, type: :job do
  let!(:user) { create :user, email: 'carlosdgild@gmail.com'}
  let!(:donation) { create :donation, user: user }

  it "enqueues a job" do
    expect do
      NotifySuccessChargeJob.perform_async(donation)
    end.to change(NotifySuccessChargeJob.jobs, :size).by(1)
  end

  it "Performs a job and sends email" do
    # Set the Sidekiq testing mode to inline
    Sidekiq::Testing.inline! do
      # Perform the action that enqueues NotifySuccessChargeJob
      NotifySuccessChargeJob.perform_async(donation.id)


      # You can also assert the job count directly
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end
