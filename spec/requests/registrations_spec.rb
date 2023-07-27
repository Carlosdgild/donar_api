# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'POST /users' do
    let!(:url) { '/users' }

    context 'when user is valid' do
      let(:valid_user_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password',
            name: 'Carlos',
            last_name: 'Gil',
            role: User::Role::USER
          }
        }
      end

      it 'creates a new user' do
        expect do
          post url, params: valid_user_params
        end.to change(User, :count).by(1)
        # Expectations
        expect(response).to have_http_status(:created)
        expect(json['message']).to eq('User created successfully')
      end
    end

    context 'when user is invalid' do
      let(:invalid_user_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'wrong_password',
            name: 'Carlos',
            last_name: 'Gil',
            role: User::Role::USER
          }
        }
      end

      it 'returns errors' do
        post url, params: invalid_user_params
        # Expectations
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].last).to eq("Password confirmation doesn't match Password")
      end

      it 'when email is taken returns errors' do
        create :user, email: 'test@example.com'
        post url, params: invalid_user_params
        # Expectations
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors'].last).to eq('Email has already been taken')
      end
    end
  end
end
