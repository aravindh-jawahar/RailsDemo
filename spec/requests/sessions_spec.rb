require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let!(:user) { create(:user, :with_role, role_name: Role::SUPER_ADMIN) }

  describe 'GET #sign_in' do
    context 'with valid credentials' do
      it 'returnses http ok' do
        FactoryBot.create(:user, :with_role, role_name: Role::SUPER_ADMIN, email: 'example123@gmail.com', password: 'example')
        get sign_in_path, params: { session: { email: 'example123@gmail.com', password: 'example' } }

        expect(response).to have_http_status :ok
      end
    end

    context 'with invalid credentials' do
      it 'returns http unauthorized' do
        FactoryBot.create(:user, :with_role, role_name: Role::SUPER_ADMIN, email: 'example123@gmail.com', password: 'example')
        get sign_in_path, params: { session: { email: 'example123@gmail.com', password: 'wrong password' } }

        expect(response).to have_http_status :bad_request
      end
    end
  end
end
