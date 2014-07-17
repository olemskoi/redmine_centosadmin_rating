require File.dirname(__FILE__) + '/../spec_helper'

describe ActivitiesController do

  before :each do
    @project   = create :project
    @evaluated = (create :member, project: @project, role_name: 'Developer').user
    @evaluator = (create :member, project: @project, role_name: 'Manager').user
    @issue     = create :issue,  project: @project, author: @evaluator, assigned_to: @evaluated
    User.current = @evaluator
    @request.session[:user_id] = @evaluator.id
  end

  describe 'GET index' do
    before :each do
      @rating = create :rating, evaluated: @evaluated, evaluator: @evaluator, issue: @issue, project: @project
    end

    it 'events include event about the created rating' do
      get :index
      expect(assigns(:events_by_day).values.first).to include(@rating)
    end
  end

end