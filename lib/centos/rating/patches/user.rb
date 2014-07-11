require_dependency 'user'

module Centos::Rating::Patches
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
        scope = self.ratings
        scope = scope.where 'project_id = ?', options[:project_id] unless options[:project_id].blank?
        scope = scope.where 'created_on <= ?', options[:date_to] unless options[:date_to].blank?
        scope = scope.where 'created_on >= ?', options[:date_from] unless options[:date_from].blank?
        scope.average :mark
      end
    end
  end
end

User.send :include, Centos::Rating::Patches::User
