# frozen_string_literal: true

class NotifySuccessChargeJob < ApplicationJob
  #
  # Job to send mail to user informing donation
  #
  include Sidekiq::Worker
  sidekiq_options queue: :mailers

  def perform(donation_id)
    donation = Donation.find_by(id: donation_id)
    SuccessDonationMailer.success_mail(donation).deliver_now
  end
end
