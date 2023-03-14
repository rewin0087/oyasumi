require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  let!(:follower) { create :user }
  let!(:following) { create :user }
  let(:follow_user_id) { following.id }
  let(:uid) { follower.uuid }
  let(:request_headers) do
    { 'HTTP_X_UID' => uid, 'Content-Type' => 'application/vnd.api+json', 'Accept' => 'application/vnd.api+json' }
  end

  describe 'POST create' do
    let(:request_params) { { follow_user_id: follow_user_id } }

    before do
      post '/api/follows', headers: request_headers, params: request_params.to_json
    end

    context 'when current user dont exist' do
      let(:uid) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when following dont exist' do
      let(:follow_user_id) { 10 }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when following exist' do
      it { expect(response).to have_http_status(:no_content) }
    end
  end

  describe 'DELETE destroy' do
    let(:following_user_id) { following.id }

    before do
      follower.follow(following)
      delete "/api/follows/#{following_user_id}", headers: request_headers
    end

    context 'when current user dont exist' do
      let(:uid) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when following dont exist' do
      let(:following_user_id) { 10 }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when following exist' do
      it { expect(response).to have_http_status(:no_content) }
    end
  end
end
