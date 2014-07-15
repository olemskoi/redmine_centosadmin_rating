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
        pars = params[:issue][:rating]
        user = ::User.current
        rating = Rating.issue_rating @issue, user

        return unless !pars.blank? && user.allowed_to?(:centos_rate, @issue.project)

        if rating
          if pars[:mark].blank?
            rating.destroy
          else
            rating.safe_attributes = pars
            rating.save
          end
        else
          unless pars[:mark].blank?
            Rating.create({
              issue_id: @issue.id,
              project_id: @issue.project_id,
              evaluator_id: user.id,
              evaluated_id: @issue.assigned_to_id,
              mark: pars[:mark],
              comments: pars[:comments]
            }) 
          end
        end
      end
    end
  end
end

IssuesController.send :include, Centos::Rating::Patches::IssuesController
