require_dependency 'user'

module CentosAdmin::Rating::Patches
  module User
    def self.included(base)
      base.class_eval do
        has_many :ratings
        has_many :centos_evaluations, class_name: 'Rating', foreign_key: :evaluator_id
      end
    end
  end
end

User.send :include, CentosAdmin::Rating::Patches::User
