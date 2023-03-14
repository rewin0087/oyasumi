FactoryBot.define do
  factory :user do
    name { 'User' }
    uuid { SecureRandom.uuid }
  end
end
