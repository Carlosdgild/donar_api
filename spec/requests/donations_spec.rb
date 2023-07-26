require 'rails_helper'

RSpec.describe "Donations", type: :request do
  describe "GET /index" do
    let!(:url) { donations_url }
    let!(:user) { create :user, :admin}

    context 'authorized access' do
    end

    context 'unauthorized access' do
      before { user.update(role: User::Role::USER)}
      it 'forbid access' do
        get url
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /donations" do
    let!(:user) { create :user, :admin}
    let!(:url) { donations_url }
    let(:valid_token) { 'tok_visa' }
    let(:params) do
      {
        donation: {
          amount: 10,
          token: valid_token,
          currency: 'usd'
        }
      }
    end

    context 'creates a donation' do
      it 'creates donation and return ok status' do
        sign_in_as(user)
        expect do
          post url, params: params
        end.to change(CreateChargeJob.jobs, :size).by(1)
        # Expectations
        expect(response).to have_http_status(:created)
        expect(json['status']).to eq(Donation::Status::PENDING.to_s)
        expect(json['amount'].to_i).to eq(params[:donation][:amount])
      end
    end

    context 'missing permit paramater' do
      before { params[:donation] = {} }
      it 'creates donation and return ok status' do
        sign_in_as(user)
        expect do
          post url, params: params
        end.to change(CreateChargeJob.jobs, :size).by(0)
        # Expectations
        expect(response).to have_http_status(:bad_request)
        expect(json['message']).to eq('Missing parameter donation')
      end
    end

    context 'missing or bad parameters' do
      it 'creates donation and return ok status' do
        params[:donation][:amount] = 'string'
        sign_in_as(user)
        expect do
          post url, params: params
        end.to change(CreateChargeJob.jobs, :size).by(0)
        # Expectations
        expect(response).to have_http_status(:bad_request)
        expect(json['message']).to eq('ArgumentError')
      end
    end

    context 'missing or bad parameters' do
      it 'creates donation and return ok status' do
        params[:donation][:token] = nil
        sign_in_as(user)
        expect do
          post url, params: params
        end.to change(CreateChargeJob.jobs, :size).by(0)
        # Expectations
        expect(response).to have_http_status(:bad_request)
        expect(json['message']).to eq('ArgumentError')
      end
    end
  end
end
