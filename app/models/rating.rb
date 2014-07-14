class Rating < ActiveRecord::Base
  self.table_name = 'centos_ratings'

  unloadable

  include Redmine::SafeAttributes

  safe_attributes 'mark', 'comments', 'evaluated_id', 'evaluator_id', 'issue_id', 'project_id'

  belongs_to :evaluated, class_name: 'User'
  belongs_to :evaluator, class_name: 'User'
  belongs_to :issue
  belongs_to :project

  validates_presence_of :evaluated, :evaluator
  validates :mark, inclusion: { in: 1..3 }, allow_blank: false

  scope :issue_rating, lambda{ |issue, user| where evaluator_id: user.id, issue_id: issue.id }

  acts_as_event title: proc{ |r| "#{r.evaluator.login} -> #{r.evaluated.login}#{ r.issue ? "(#{r.issue.subject})" : '' }: #{r.mark}" }, 
                description: :comments, 
                author: :evaluator, 
                url: proc{ |r| { controller: 'ratings', action: 'show', id: r.id } }

  acts_as_activity_provider find_options: { include: [:project] },
                            author_key: :evaluator_id

  before_validation :set_project

  def editable_by?( user )
    user == evaluator || user.admin?
  end

  private
  
  def set_project
    self.project_id = issue.project_id if project_id.nil? && !issue_id.nil?
  end
end
