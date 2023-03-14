require 'rails_helper'

RSpec.describe 'Sleep Records', type: :request do
  describe 'GET index' do
    let!(:user) { create :user }
    let!(:user_1) { create :user }
    let!(:user_2) { create :user }
    let!(:timesheet_1) { create :timesheet, user: user_1, sleep_time_in_seconds: 2, id: 1 }
    let!(:timesheet_2) { create :timesheet, user: user_1, sleep_time_in_seconds: 4, id: 2 }
    let!(:timesheet_3) { create :timesheet, user: user_2, sleep_time_in_seconds: 7, id: 3 }
    let!(:timesheet_4) { create :timesheet, user: user_2, clock_out: nil }
    let!(:timesheet_5) { create :timesheet, user: user_2, created_at: 2.weeks.ago }
    let!(:timesheet_6) { create :timesheet, user: user_1, sleep_time_in_seconds: nil }
    let(:uid) { user.uuid }
    let(:request_headers) do
      { 'HTTP_X_UID' => uid, 'Content-Type' => 'application/vnd.api+json', 'Accept' => 'application/vnd.api+json' }
    end

    before do
      user.follow(user_1)
      user.follow(user_2)

      get '/api/sleep-records', headers: request_headers
    end

    context 'when current user dont exist' do
      let(:uid) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when current user exist' do
      it 'return results' do
        result = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(result['data'].count).to eq(3)
        expect(result['data'].pluck('id')).to eq(['3', '2', '1'])
      end
    end
  end
end
