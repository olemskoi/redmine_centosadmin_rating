require_dependency 'project'

module Centos::Rating::Patches
  module Project
    def self.included(base)
      base.send :include, InstanceMethods

      base.class_eval do
        has_many :ratings, class_name: 'StaffRating'
      end
    end

    module InstanceMethods
      def users_available_to(action)
        self.users.select {|u| u.allowed_to?(action, self)}
      end
    end
  end
end


