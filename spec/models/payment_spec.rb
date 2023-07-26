require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) { create(:payment) }

  describe "validations" do
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe "associations" do
    it do
      expect(payment).to belong_to(:user)
      expect(payment).to have_one(:donation)
    end
  end
end
