require 'rails_helper'

RSpec.describe "Donations", type: :request do
  describe "GET /index" do
    let!(:url) { donations_url }
    let!(:time) { Time.now }
    let!(:user) { create :user, :admin }
    let!(:donation) { create :donation, created_at: time}
    let!(:donation_2) { create :donation, created_at: time }
    let!(:future_date) { time.advance(days: 1) }
    let!(:past_date) { time.advance(days: -1) }

    context ' with authorized access' do
      context 'without filters' do
        it 'retrieves all donations' do
          sign_in_as(user)
          get url
          # Expectations
          expect(response).to have_http_status(:ok)
          expect(json['donations'].count).to eq(2)
        end
      end

      context 'with filters' do
        it 'retrieves all donations from a date' do
          # Creating elegible record
          elegible_donation = create :donation, created_at: future_date
          params = {start_date: future_date }
          sign_in_as(user)
          get url, params: params
          # Expectations
          expect(response).to have_http_status(:ok)
          expect(json['donations'].count).to eq(1)
          expect(json['donations'].last['id']).to eq(elegible_donation.id)
        end

        it 'retrieves all donations from within dates' do
          # Creating unelegible record
          unelegible_donation = create :donation, created_at: future_date
          params = {start_date: past_date, end_date: time }
          sign_in_as(user)
          get url, params: params
          # Expectations
          expect(response).to have_http_status(:ok)
          expect(json['donations'].count).to eq(2)
          json['donations'].each do |donation|
            expect(donation['id']).not_to be(unelegible_donation.id)
          end
        end
      end

      context 'with pagination' do
        it 'retrieves the number of min records per page by default' do
          FactoryBot.create_list(:donation, 10)
          sign_in_as(user)
          get url
          # Expectations
          expect(response).to have_http_status(:ok)
          expect(json['donations'].count).to eq(Pagination::DEFAULT_MIN_PER_PAGE)
        end

        it 'retrieves the number of min records send by params' do
          FactoryBot.create_list(:donation, 10)
          params = { per_page: 2 }
          sign_in_as(user)
          get url, params: params
          # Expectations
          expect(response).to have_http_status(:ok)
          expect(json['donations'].count).to eq(2)
        end
      end
    end

    context 'with unauthorized access' do

      before { user.update(role: User::Role::USER)}

      it 'forbid access' do
        get url
        expect(response).to have_http_status(:unauthorized)
      end

      it 'forbid access' do
        sign_in_as(user)
        get url
        expect(response).to have_http_status(:forbidden)
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

    context 'with authorized access' do
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

    context 'with unauthorized access' do

      before { user.update(role: User::Role::USER)}

      it 'forbid access' do
        # needs to be logged
        post url, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /donations" do
    let!(:user) { create :user, :admin }
    let(:instructions) { 'instructions' }
    let!(:donation) { create :donation, instructions: instructions}
    let!(:url) { donation_url(donation.id) }
    let(:params) do
      {
        donation: {
          instructions: 'Updated Instructions'
        }
      }
    end

    context 'with authorized access' do
      it 'updates the donation' do
        sign_in_as(user)
        put url, params: params
        # Expectations
        expect(response).to have_http_status(:ok)
        expect(json['description']).not_to be(instructions)
      end

      context 'with wrong params' do
        it 'does not update when not sending donation object as required' do
          params = {}
          sign_in_as(user)
          put url, params: params
          # Expectations
          expect(response).to have_http_status(:bad_request)
          expect(json['message']).to eq("Missing parameter donation")
        end

        it 'does not update amount' do
          params[:donation][:amount] = 50
          sign_in_as(user)
          put url, params: params
          # Expectations
          expect(response).to have_http_status(:ok)
          expect(json['amount']).not_to eq(50)
        end

        it 'does not find the donation' do
          donation.destroy
          sign_in_as(user)
          put url, params: params
          # Expectations
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'with unauthorized access' do

      before { user.update(role: User::Role::USER)}

      it 'forbid access' do
        put url
        expect(response).to have_http_status(:unauthorized)
      end

      it 'forbid access' do
        sign_in_as(user)
        put url
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /donations" do
    let!(:user) { create :user, :admin }
    let(:instructions) { 'instructions' }
    let!(:donation) { create :donation, instructions: instructions}
    let!(:url) { donation_url(donation.id) }

    context 'with authorized access' do
      it 'deletes a donation' do
        sign_in_as(user)
        delete url
        # Expectations
        expect(response).to have_http_status(:ok)
        expect(json['deleted_at']).to be_present
        expect(json['id']).to be(donation.id)
      end

      context 'with wrong params' do
        it 'does not find the donation' do
          donation.destroy
          sign_in_as(user)
          delete url
          # Expectations
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'with unauthorized access' do
      before { user.update(role: User::Role::USER)}

      it 'forbid access' do
        delete url
        expect(response).to have_http_status(:unauthorized)
      end

      it 'forbid access' do
        sign_in_as(user)
        delete url
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
