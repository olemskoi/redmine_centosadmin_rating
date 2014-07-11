require_dependency 'project'

module CentosAdmin::Rating::Patches
  module Project
    def self.included(base)
      base.class_eval do
        has_many :ratings, through: :issues
      end
    end
  end
end

Project.send :include, CentosAdmin::Rating::Patches::Project


