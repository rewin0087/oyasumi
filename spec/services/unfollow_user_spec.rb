require 'rails_helper'

RSpec.describe UnfollowUser do
  describe '#call' do
    let!(:follower) { create :user }
    let!(:following) { create :user }
    let(:follow_user_id) { following.id }

    subject { described_class.new(follow_user_id).call(user: follower) }

    context 'when following user exist' do
      before { follower.follow(following) }

      it 'stop following the user successfully' do
        expect { subject }.to change(follower.following_users, :count).by(-1)

        expect(follower.following_users.first).to be_nil
      end
    end

    context 'when following dont exist' do
      let(:follow_user_id) { 3 }

      it 'raise error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
