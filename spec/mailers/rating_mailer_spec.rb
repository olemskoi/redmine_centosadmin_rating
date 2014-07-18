require File.dirname(__FILE__) + '/../spec_helper'

describe RatingMailer do
  before do
    @project   = create :project
    @developer = create :member, project: @project, role_name: 'Developer'
    @author    = create :member, project: @project, role_name: 'Manager'
    @issue     = create :issue, project: @project, author: @author.user, assigned_to: @developer.user
  end

  it '#must_rate' do
    email = RatingMailer.must_rate @issue

    expect( email.to ).to eq [ @author.user.mail ]
    expect( email.body.blank? ).to be false

    expect{ email.deliver }.to change{ ActionMailer::Base.deliveries.size }.by 1
  end
end
