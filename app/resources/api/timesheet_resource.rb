class Api::TimesheetResource < JSONAPI::Resource
  attributes :clock_in, :clock_out, :created_at

  def self.records(options = {})
    context = options[:context]
    context[:current_user].timesheets
  end
end
