# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  describe "validations" do
    it '' do
      expect(user).to validate_presence_of(:name)
      expect(user).to validate_presence_of(:last_name)
      expect(user).to define_enum_for(:role).with_values(%i[user admin])
      expect(user).to validate_uniqueness_of(:email).ignoring_case_sensitivity
    end
  end

  describe "associations" do
    it do
      expect(user).to have_many(:donations)
      expect(user).to have_many(:payments)
      expect(user).to have_many(:login_activities)
      expect(user).to have_db_index(:email)
    end
  end
end
