require File.dirname(__FILE__) + '/../spec_helper'

describe Project do

  describe '.users_allowed_to' do
    before do
      @project = create :project
      @developer = (create :member, project: @project, role_name: 'Developer').user
      @manager   = (create :member, project: @project, role_name: 'Manager').user
    end
    subject {@project.users_allowed_to :centos_be_rated}
    it { should     include(@developer) }
    it { should_not include(@manager)   }
  end
end