class ClockOut
  def call(user:)
    user.timesheets.active.last.tap do |record|
      time_now = Time.zone.now
      record.update(clock_out: time_now, sleep_time_in_seconds: time_now - record.clock_in) if record
    end
  end
end
