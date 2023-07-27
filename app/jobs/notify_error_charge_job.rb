# frozen_string_literal: true

class NotifyErrorChargeJob < ApplicationJob
  #
  # Job to send mail to user with error donation
  #
  include Sidekiq::Worker
  sidekiq_options queue: :mailers

  def perform(donation_id)
    donation = Donation.find_by(id: donation_id)
    ErrorDonationMailer.error_mail(donation).deliver_now
  end
end
