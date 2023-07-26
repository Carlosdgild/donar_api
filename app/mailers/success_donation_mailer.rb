class SuccessDonationMailer < ApplicationMailer
  def success_mail(donation)
    @user = donation.user
    @email = @user.email
    @amount = donation.amount
    @receipt_url = donation&.payment&.receipt_url
    @name = @user.full_name
    @status = donation.status
    @description = donation.description

    mail(to: donation.user.email, subject: "Thank you for your donation!")
  end
end
