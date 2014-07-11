require_dependency 'project'

module Centos::Rating::Patches
  module Project
    def self.included(base)
      base.class_eval do
        has_many :ratings
      end
    end
  end
end

Project.send :include, Centos::Rating::Patches::Project


