require 'rails_helper'

RSpec.describe ClockOut do
  describe '#call' do
    let!(:user) { create :user }
    let(:clock_out) { nil }
    let!(:timesheet) { create :timesheet, user: user, clock_out: clock_out, clock_in: '2023-03-09 15:20:48 UTC' }

    subject { described_class.new.call(user: user) }

    before do
      Timecop.freeze('2023-03-09 15:24:48 UTC')
    end

    after do
      Timecop.return
    end

    context 'when has active clocked in' do
      it 'clocked out successfully' do
        subject

        timesheet.reload

        expect(timesheet.clock_out).to eq('2023-03-09 15:24:48 UTC')
        expect(timesheet.sleep_time_in_seconds.to_f).to eq(240.0)
      end
    end

    context 'when has no active clocked in' do
      let(:clock_out) { '2023-03-09 15:25:48 UTC' }

      it 'didnt change the record' do
        subject

        timesheet.reload

        expect(timesheet.clock_out).to eq('2023-03-09 15:25:48 UTC')
      end
    end
  end
end
