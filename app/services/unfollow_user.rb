class UnfollowUser
  def initialize(follow_user_id)
    @follow_user_id = follow_user_id
  end

  def call(user:)
    followable_user = User.find(follow_user_id)
    user.stop_following(followable_user)
  end

  private

  attr_reader :follow_user_id
end
