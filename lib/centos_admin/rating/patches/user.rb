require_dependency 'member'

module CentosAdmin::Rating::Patches
  module User
    def self.included(base)
      base.class_eval do
        has_many :centos_ratings, class_name: 'CentosAdmin::Rating::Rating'
        has_many :centos_evaluations, class_name: 'CentosAdmin::Rating::Rating', foreign_key: :evaluator_id
      end
    end
  end
end

User.send :include, CentosAdmin::Rating::Patches::User
