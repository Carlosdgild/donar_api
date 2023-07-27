# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'donation.api.carlos.gil@gmail.com'
  layout 'mailer'
end
