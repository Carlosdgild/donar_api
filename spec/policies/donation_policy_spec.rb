# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DonationPolicy, type: :policy do
  let(:donation) { Donation }
  let(:actions) { %i[index create update destroy] }
  let(:forbidden_actions) { %i[index update destroy] }

  context 'with validate authorizations for user object with admin role on
    Donation policies' do
    # subject { described_class.new(user, donation) }
    subject(:policy) { described_class.new(user, donation) }

    let!(:user) { create :user, :admin }

    it { is_expected.to permit_actions(actions) }
  end

  context 'without admin role on Donation policies' do
    # subject { described_class.new(user, donation) }
    subject(:policy) { described_class.new(user, donation) }

    let!(:user) { create :user }

    it { is_expected.to forbid_actions(forbidden_actions) }
  end
end
