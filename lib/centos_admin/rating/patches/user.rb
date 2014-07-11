require_dependency 'user'

module CentosAdmin::Rating::Patches
  module User
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        has_many :ratings, foreign_key: :evaluated_id
        has_many :centos_evaluations, class_name: 'Rating', foreign_key: :evaluator_id
      end
    end

    module InstanceMethods
      def rating(options = {})
        date_to   = options[:date_to] || Date.tomorrow
        scope = self.ratings
        scope = scope.includes(:issue)
                     .where 'issues.project_id = ?', options[:project_id] unless options[:project_id].blank?
        scope = scope.where 'centos_ratings.created_on <= ?', date_to
        scope = scope.where 'centos_ratings.created_on >= ?', options[:date_from] unless options[:date_from].blank?
        scope.sum(:mark).to_f / scope.size
      end
    end
  end
end

User.send :include, CentosAdmin::Rating::Patches::User
