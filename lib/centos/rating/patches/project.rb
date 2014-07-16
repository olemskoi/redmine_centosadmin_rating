require_dependency 'project'

module Centos::Rating::Patches
  module Project
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        has_many :ratings
      end
    end

    module InstanceMethods
      def users_allowed_to(action)
        self.members.map {|m| m.user if m.user.allowed_to?(action, self)}
      end
    end
  end
end

Project.send :include, Centos::Rating::Patches::Project


