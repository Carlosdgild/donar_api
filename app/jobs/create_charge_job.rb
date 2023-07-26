class CreateChargeJob
  #
  # Calls the service class for processing
  #
  include Sidekiq::Worker
  sidekiq_options queue: :import

  def perform(donation_id, token)
    donation = Donation.find_by(id: donation_id)
    response = nil
    donation.with_lock do
      response = create_charge!(donation, token)
      update_models!(donation, response)
    rescue StandardError, Stripe::InvalidRequestError => e
      update_models!(donation,  { error_info: e.message })
      NotifyErrorChargeJob.perform_async(donation.id)
      Rails.logger.error("An error occurred in CreateChargeJob: #{e.message}")
    end
    donation.reload
    NotifySuccessChargeJob.perform_async(donation.id) if donation.succeeded?
  end

  private

  # Creates a call to Stripe in order to create a new charge
  def create_charge!(donation, token)
    stripe_request = {
      source: token,
      currency: donation.currency,
      amount: (donation.amount * 100).to_i,
      description: donation.description || 'Anonymous Donation'
    }

    stripe_charge = Stripe::Charge.create stripe_request
  end

  # Updates models whether charge was completed or not
  def update_models!(donation, response)
      status = case response[:status]
        when 'succeeded'
          Payment::Status::SUCCEEDED
        when 'in_progress'
          Payment::Status::PENDING
        else
          payment_arguments = {
            error_info: response
          }
          Payment::Status::FAILED
        end

      payment_arguments ||= {
        charge_id: response[:id],
        payment_method: response[:payment_method],
        fingerprint:  response[:payment_method_details][:card][:fingerprint],
        card_last_number: response[:source][:last4],
        brand: response[:source][:brand],
        receipt_url: response[:receipt_url]
      }

      payment_arguments.merge!({
        user_id: donation.user_id,
        status: status,
        amount: donation.amount
      })

      payment = Payment.create!(payment_arguments)

      donation.update!(payment: payment, status: status)
  end
end
