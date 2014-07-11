require File.dirname(__FILE__) + '/../spec_helper'

describe true do
  fixtures :issue_statuses, :roles, :trackers, :enumerations

  it do
    Role.find_by_name( 'Manager' ).add_permission! :centos_rate
    Role.find_by_name( 'Developer' ).add_permission! :centos_be_rated

    project = create :project
    manager = create :member, project: project, role_name: 'Manager'
    developer = create :member, project: project, role_name: 'Developer'
    issue = create :issue, project: project, author: manager.user, assigned_to: developer.user

    puts project.members.count

    expect( 1 ).to eq 1
  end
end
