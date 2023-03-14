require 'rails_helper'

RSpec.describe SleepRecords do
  describe '#call' do
    let!(:user) { create :user }
    let!(:user_1) { create :user }
    let!(:user_2) { create :user }
    let!(:timesheet_1) { create :timesheet, user: user_1, sleep_time_in_seconds: 2 }
    let!(:timesheet_2) { create :timesheet, user: user_1, sleep_time_in_seconds: 4 }
    let!(:timesheet_3) { create :timesheet, user: user_2, sleep_time_in_seconds: 7 }
    let!(:timesheet_4) { create :timesheet, user: user_2, clock_out: nil }
    let!(:timesheet_5) { create :timesheet, user: user_2, created_at: 2.weeks.ago }
    let!(:timesheet_6) { create :timesheet, user: user_1, sleep_time_in_seconds: nil }

    before do
      user.follow(user_1)
      user.follow(user_2)
    end

    subject { described_class.new.call(user: user) }

    it { expect(subject).to eq([timesheet_3, timesheet_2, timesheet_1]) }
  end
end
