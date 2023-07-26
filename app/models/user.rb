# frozen_string_literal: true
class User < ApplicationRecord
  #extend Devise::Models
  acts_as_paranoid
  # devise
  devise :database_authenticatable, :registerable, :recoverable, :trackable
  # associations
  has_many :login_activities
  has_many :donations
  has_many :payments

  module SignupStatus
    CREATED = :created
    AUTHORIZED = :authorized
    REJECTED = :rejected
    LIST = {
      CREATED => 0,
      AUTHORIZED => 1,
      REJECTED => 2
    }.freeze
  end

  module Role
    USER = :user
    ADMIN = :admin
    LIST = {
      USER => 0,
      ADMIN => 1
    }.freeze
  end

  # Enum
  enum signup_status: SignupStatus::LIST
  enum role: Role::LIST
  # Validations
  validates :name, :last_name, presence: true
  validates :email, uniqueness: true, presence: true

  def create_activity!(user_agent, address_ip)
    self.login_activities.create!(
      user_agent: user_agent,
      address_ip: address_ip
    )
  end

  def full_name
    "#{name} #{last_name}"
  end

end
