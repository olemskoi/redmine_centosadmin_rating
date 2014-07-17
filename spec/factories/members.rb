FactoryGirl.define do
  factory :member do
    ignore do
      role_name ''
    end

    user
    project
    role_ids { [ Role.find_by_name(role_name).id ] }
  end
end
