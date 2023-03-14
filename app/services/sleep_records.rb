class SleepRecords
  def call(user:, since: 1.week.ago)
    user_ids = user.following_users.pluck(:id)
    Timesheet.unscoped.includes(:user).since(since).sleep_records(user_ids)
  end
end
