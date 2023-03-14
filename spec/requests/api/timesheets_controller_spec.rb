require 'rails_helper'

RSpec.describe 'Timesheets', type: :request do
  let!(:user) { create :user }
  let(:uid) { user.uuid }
  let(:request_headers) do
    { 'HTTP_X_UID' => uid, 'Content-Type' => 'application/vnd.api+json', 'Accept' => 'application/vnd.api+json' }
  end

  describe 'GET index' do
    let!(:timesheet_1) { create :timesheet, user: user, sleep_time_in_seconds: 2, id: 1 }
    let!(:timesheet_2) { create :timesheet, user: user, sleep_time_in_seconds: 4, id: 2 }

    before { get '/api/timesheets', headers: request_headers }

    context 'when current user dont exist' do
      let(:uid) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when current user exist' do
      it 'return results' do
        result = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(result['data'].count).to eq(2)
        expect(result['data'].pluck('id')).to eq(['2', '1'])
      end
    end
  end

  describe 'POST clock_in' do
    before { post '/api/timesheets/clock-in', headers: request_headers }

    context 'when current user dont exist' do
      let(:uid) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when has no active clocked in exist yet' do
      it 'return success' do
        expect(response).to have_http_status(:no_content)
        timesheets = user.timesheets

        expect(timesheets.count).to eq(1)
        expect(timesheets.first.clock_out).to be_nil
      end
    end

    context 'when has active clocked in exist' do
      before { create :timesheet, user: user }

      it 'return success' do
        expect(response).to have_http_status(:no_content)
        timesheets = user.timesheets
        expect(timesheets.count).to eq(2)
        expect(timesheets.first.clock_out).not_to be_nil
        expect(timesheets.last.clock_out).to be_nil
      end
    end
  end

  describe 'POST clock_out' do
    context 'when current user dont exist' do
      let(:uid) { nil }

      before { post '/api/timesheets/clock-out', headers: request_headers }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when has active clocked in' do
      before { create :timesheet, user: user, clock_out: nil, sleep_time_in_seconds: nil }

      it 'return success' do
        post '/api/timesheets/clock-out', headers: request_headers

        expect(response).to have_http_status(:no_content)
        timesheets = user.timesheets

        expect(timesheets.count).to eq(1)
        expect(timesheets.first.clock_out).not_to be_nil
        expect(timesheets.first.sleep_time_in_seconds).not_to be_nil
      end
    end

    context 'when has no active clocked in' do
      before { create :timesheet, user: user }

      it 'return success' do
        post '/api/timesheets/clock-out', headers: request_headers

        expect(response).to have_http_status(:no_content)
        timesheets = user.timesheets

        expect(timesheets.count).to eq(1)
        expect(timesheets.first.clock_out).not_to be_nil
      end
    end
  end
end
