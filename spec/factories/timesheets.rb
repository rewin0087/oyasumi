FactoryBot.define do
  factory :timesheet do
    clock_in { Time.zone.now }
    clock_out { Time.zone.now + 4.hours  }
    user { nil }
  end
end
