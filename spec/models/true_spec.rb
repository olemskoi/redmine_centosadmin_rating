require File.dirname(__FILE__) + '/../spec_helper'

describe true do
  fixtures :issue_statuses, :roles, :trackers, :enumerations

  it do

    project = create :project
    manager =   create :member, project: project, role_name: 'Manager'
    developer = create :member, project: project, role_name: 'Developer'
    issue = create :issue, project: project, author: manager.user, assigned_to: developer.user

    puts project.members.count

    expect( 1 ).to eq 1
  end
end
