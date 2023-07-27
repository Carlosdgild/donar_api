require 'rails_helper'

describe CreateChargeJob, type: :job do
  let!(:donation) { create :donation }
  let!(:valid_token) { 'tok_visa' }
  it "enqueues a CreateChargeJob" do
    expect do
      CreateChargeJob.perform_async(donation, valid_token)
    end.to change(CreateChargeJob.jobs, :size).by(1)
  end

  it "performs a CreateChargeJob worker" do
    Sidekiq::Testing.inline! do
      expect_any_instance_of(CreateChargeJob)
      .to receive(:update_models!)
      .and_call_original
      VCR.use_cassette('stripe_card_payment',
        match_requests_on: [:stripe_api]) do
        CreateChargeJob.perform_async(donation.id, valid_token)
      end

      expect(Sidekiq::Worker.jobs.size).to eq(1)

      donation.reload
      payment = Payment.last

      expect(donation.payment_id).to eq(payment.id)
      expect(donation.status).to eq(payment.status)
      expect(donation.amount).to eq(payment.amount)
    end
  end
end
