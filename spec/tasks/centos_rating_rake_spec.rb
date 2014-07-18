require File.dirname(__FILE__) + '/../spec_helper'
require 'rake'

describe 'rake' do
  before :all do
    Rake.application.rake_require 'tasks/centos_rating'
    Rake::Task.define_task :environment
  end

  def run_task(task, args = nil)
    Rake::Task[task].reenable
    Rake.application.invoke_task "#{task}#{ args && "[#{args}]" }"
  end

  before do
    Setting.plugin_redmine_centosadmin_rating['must_rate'] = true

    @project   = create :project
    developer = create( :member, project: @project, role_name: 'Developer' ).user
    manager   = create( :member, project: @project, role_name: 'Manager' ).user
    reporter  = create( :member, project: @project, role_name: 'Reporter' ).user

    @assigns = [
      [manager, developer],
      [manager, reporter],
      [reporter, developer],
      [reporter, reporter],
      [manager, nil]
    ]
  end

  def create_issue( people, status, updated_on )
    issue = create :issue, 
      project: @project,
      author: people[0], 
      assigned_to: people[1],
      status: IssueStatus.find_by_name(status)

    ActiveRecord::Base.connection.execute("update issues set updated_on='#{updated_on.to_s(:db)}' where id = #{issue.id}")

    issue
  end

  def create_issues( indexes, status, updated_on )
    indexes.each do |index|
      create_issue @assigns[index], status, updated_on
    end
  end

  def must_date
    DateTime.now - Setting.plugin_redmine_centosadmin_rating['must_day'].to_i.days
  end

  subject{ expect{ run_task 'centos_rating:must_rate' } }

  it 'no_valid' do
    create_issues 0..4, 'New', must_date
    create_issues 0..4, 'Closed', DateTime.now
    create_issues 1..4, 'Closed', must_date
    subject.not_to change{ ActionMailer::Base.deliveries.size }
  end

  describe 'one valid' do
    before do
      @issue = create_issue @assigns[0], 'Closed', must_date
    end

    it 'send' do
      subject.to change{ ActionMailer::Base.deliveries.size }.by 1
    end

    it 'update sended' do
      subject.to change{ @issue.reload.must_rate_sended }.from(false).to true
    end

    it 'doable' do
      subject.to change{ ActionMailer::Base.deliveries.size }
      subject.not_to change{ ActionMailer::Base.deliveries.size }
    end
  end

end
