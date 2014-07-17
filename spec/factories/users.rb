FactoryGirl.define do
  factory :user do
    sequence(:login){ |n| "login#{n}" }
    sequence(:mail){ |n| "mail#{n}@example.com" }
    status 1
    firstname 'First_name'
    lastname 'Last_name'
  end
end
