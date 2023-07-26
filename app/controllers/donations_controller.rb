class DonationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_donation!, only: %i[update destroy]

  # Endpoint to retrieve Donations
  def index
    authorize Donation
    data, meta = paginate_resources policy_scope(Donation).filter_by_date(params[:start_date],params[:end_date])
    render json: data, meta: meta, adapter: :json
  end

  # Enpoint to create a new Donation
  # It will always returns donation as pending. Worker will process it and change its status
  def create
    authorize Donation
    donation = DonationService::CreateDonationService::perform(
      current_user,
      request.user_agent,
      request.remote_ip ,
      create_params
    )
    json_response donation, :created
  end

  # It updates only the instructions due a donation cannot be updated nor the payment
  def update
    authorize @donation
    @donation.update(update_donation_params)
    json_response @donation
  end

  def destroy
    # Think this has to be refound action to stripe,
    # but it seems that I have to create first a PaymentIntend
    # and I am lack of time. So an idea could be to set a cronjob
    # that executes everyday to find what donations are with deleted_at != null
    # and also create another table like "refound_donation" which will be linked
    # to every donation that is marked deleted_at. So the cronjob will execute a query
    # to see what donation in that day must be send to Stripe::Refound
    authorize @donation
    json_response @donation.destroy
  end

  private

  # Allowed params to create a new donation
  def create_params
    params.require(:donation).permit(
      :amount,
      :token,
      :currency,
      :description,
      :instructions
    )
  end

  # Finds a existing donation. Otherwise raises ActiveRecord::RecordNotFound
  def find_donation!
    @donation = policy_scope(Donation).find params[:id]
  end

  # Allowed parameters to update a Donation
  def update_donation_params
    params.require(:donation).permit(
      :instructions
    )
  end
end
