FactoryGirl.define do
  factory :project do
    sequence(:name){ |n| "Project#{n}" }
    sequence(:identifier){ |n| "project#{n}" }
    description 'project'
    is_public true
    inherit_members false
    status 1
    time_reserve 0.0
    enabled_module_names ['issue_tracking', 'time_tracking', 'news', 'documents', 'files', 'wiki', 'repository', 'boards', 'calendar', 'gantt', 'centosadmin_rating']
  end
end
