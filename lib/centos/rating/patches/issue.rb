require_dependency 'issue'

module Centos::Rating::Patches
  module Issue
    def self.included(base)
      base.class_eval do
        has_many :ratings
      end
    end
  end
end

Issue.send :include, Centos::Rating::Patches::Issue
