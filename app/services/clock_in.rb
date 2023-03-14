class ClockIn
  def call(user:)
    ClockOut.new.call(user: user)

    user.timesheets.create(clock_in: Time.zone.now)
  end
end
