# frozen_string_literal: true

module DonationService
  #
  # Service that creates a donation and enquees a job to communicate with Stripe
  #

  class CreateDonationService < ApplicationService
    attr_reader :user, :user_agent, :address_ip
    attr_accessor :currency, :amount, :token, :description, :instructions

    def initialize(current_user, user_agent = nil, address_ip = nil, args = {})
      @user = current_user
      @user_agent = user_agent
      @address_ip = address_ip
      args.each { |key, val| send "#{key}=", val }
      @currency ||= 'usd'
      @amount = amount.to_i
    end

    def perform
      check_values!
      create_donation!
    end

    private

    # Returns ArgumentError if ammount or token are not valid
    def check_values!
      raise ArgumentError if !@amount.positive? || !token.is_a?(String)
    end

    # Transaction to create a new Donation
    def create_donation!
      ActiveRecord::Base.transaction do
        activity = user.create_activity!(user_agent, address_ip)
        donation = Donation.create!(
          amount: amount,
          currency: currency,
          description: @description || 'Anonymous Donation',
          user: user,
          status: Donation::Status::PENDING,
          instructions: instructions,
          login_activity: activity
        )
        CreateChargeJob.perform_async(donation.id, token)

        donation
      rescue StandardError
        log_message('Transaction failed', 'error')
        raise ActiveRecord::Rollback
      end
    end

    def log_message(message, level)
      Rails.logger.public_send(level, message)
    end
  end
end
