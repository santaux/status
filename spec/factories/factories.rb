require 'faker'

FactoryGirl.define do
  factory :project do
    namespace
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    host { Faker::Internet.url }
  end

  factory :namespace do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
  end

  factory :report do
    project
    code 200
    message "OK"
    delay_time 0.234
    response_time 0.567
  end

  factory :failed_report, class: Report do
    project
    code 0
    message "Timeout::Error"
    delay_time 0
    response_time 0
  end
end
