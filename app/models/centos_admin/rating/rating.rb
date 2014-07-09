module CentosAdmin::Rating
  class Rating < ActiveRecord::Base
    self.table_name = 'centos_admin_ratings'

    belongs_to :evaluated, class_name: 'User'
    belongs_to :evaluator, class_name: 'User'
    belongs_to :issue

    validates_presence_of :evaluated, :evaluator
    validates :mark, inclusion: { in: 1..3 }

    scope :issue_rating, lambda{ |issue, user| where evaluator_id: user.id, issue_id: issue.id }
  end
end
