require_dependency 'issues_controller'

module Centos::Rating::Patches
  module IssuesController
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        after_filter :update_rating, only: :update
      end
    end

    module InstanceMethods
      protected
      def update_rating
        rating_from_params = params[:issue][:rating]
        return unless !rating_from_params.blank? && ::User.current.allowed_to?(:centos_rate, @issue.project)
        rating = ::Rating.find_or_initialize_by issue_id: @issue.id,
                                                evaluator_id: ::User.current.id,
                                                evaluated_id: rating_from_params.delete(:evaluated_id)
        return rating.destroy if rating_from_params[:mark].blank?
        rating.safe_attributes = rating_from_params
        rating.save
      end
    end
  end
end

IssuesController.send :include, Centos::Rating::Patches::IssuesController
