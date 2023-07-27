# frozen_string_literal: true

class ErrorDonationMailer < ApplicationMailer
  def error_mail(donation)
    @payment = donation.payment
    @amount = donation.amount
    @user = donation.user
    @name = @user.full_name
    @status = donation.status
    @description = donation.description

    mail(to: donation.user.email, subject: 'Error in your donation')
  end
end
