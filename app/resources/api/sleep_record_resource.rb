class Api::SleepRecordResource < JSONAPI::Resource
  attributes :clock_in, :clock_out, :sleep_time_in_seconds, :user_name, :user_id, :created_at
  model_name 'Timesheet'

  def self.records(options = {})
    context = options[:context]
    SleepRecords.new.call(user: context[:current_user])
  end

  def user_name
    _model.user.name
  end
end
