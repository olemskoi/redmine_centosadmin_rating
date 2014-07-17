FactoryGirl.define do
  factory :issue do
    subject 'Feature'
    description 'feature'
    is_private false
    done_ratio 0
    tracker { Tracker.find_by_name 'Feature request' }
    status { IssueStatus.find_by_name 'New' }
    priority { IssuePriority.find_by_name 'Normal' }
  end
end
