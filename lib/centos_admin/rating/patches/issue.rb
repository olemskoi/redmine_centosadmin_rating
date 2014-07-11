require_dependency 'issue'

module CentosAdmin::Rating::Patches
  module Issue
    def self.included(base)
      base.class_eval do
        has_many :ratings
      end
    end
  end
end

Issue.send :include, CentosAdmin::Rating::Patches::Issue
