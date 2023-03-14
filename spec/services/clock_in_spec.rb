require 'rails_helper'

RSpec.describe ClockIn do
  describe '#call' do
    let!(:user) { create :user }

    subject { described_class.new.call(user: user) }

    before do
      expect(ClockOut).to receive_message_chain(:new, :call).with(user: user)
    end

    it { expect { subject }.to change(user.timesheets, :count).by(1) }
  end
end
