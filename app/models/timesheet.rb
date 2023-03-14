class Timesheet < ApplicationRecord
  belongs_to :user

  validates :clock_in, presence: true

  scope :active, -> { where(clock_out: nil) }
  scope :since, -> (date) { where('timesheets.created_at > ?', date) }
  scope :sleep_records, -> (user_ids) { where(user_id: user_ids).where.not(sleep_time_in_seconds: nil).where.not(clock_out: nil).order(sleep_time_in_seconds: 'DESC') }

  default_scope { order(created_at: 'DESC') }
end
