require File.dirname(__FILE__) + '/../spec_helper'

describe RatingsController do
  fixtures :users, :issues

  let(:rating)    {create :rating, evaluated: @evaluated, evaluator: @evaluator, issue: @issue }

  before :each do
    @project   = create :project
    @evaluated = (create :member, project: @project, role_name: 'Developer').user
    @evaluator = (create :member, project: @project, role_name: 'Manager').user
    @issue     = create :issue,  project: @project, author: @evaluator, assigned_to: @evaluated
    User.current = @evaluator
    @request.session[:user_id] = @evaluator.id
  end

  let(:valid_attributes) do
    {evaluated_id: @evaluated, mark: 1, comments: 'ok', issue_id: @issue}
  end

  describe 'GET index' do
    before :each do
      @ratings = [rating]
      #puts Rating.count
    end

    it 'assigns all ratings as @ratings' do
      get :index, project_id: @project.id
      expect(assigns(:entries)).to eq(@ratings)
    end
  end

  describe 'GET show' do
    before :each do
      @rating = rating
      get :show, id: @rating
    end

    it 'assigns rating as @rating' do
      expect(assigns :rating).to eq(@rating)
    end
  end

  describe 'GET new' do
    it 'assigns a new rating as @raiting' do
      get :new
      assigns(:rating).should be_a_new(Rating)
    end

    describe 'as subresource of issue' do
      before :each do
        get :new, issue_id: @issue
      end

      it 'set issue for @rating' do
        expect(assigns(:rating).issue).to eq(@issue)
      end

      it 'set evaluated as @issue.assigned_to' do
        expect(assigns(:rating).evaluated).to eq(@issue.assigned_to)
      end
    end

    describe 'as subresource of users' do
      before :each do
        @user = @evaluated
        get :new, user_id: @user
      end

      it 'set evaluated as @user' do
        expect(assigns(:rating).evaluated).to eq(@user)
      end
    end
  end

  describe 'POST create' do
    describe 'with valid attributes' do
      it 'creates a new CentosRating' do
        expect {
          post :create, rating: valid_attributes
        }.to change{Rating.count}.by(1)
      end
      it 'assigns a newly created rating as @rating' do
        post :create, rating: valid_attributes
        expect(assigns :rating).to be_a(Rating)
        expect(assigns :rating).to be_persisted
      end

      it 'redirects to the created rating' do
        post :create, rating: valid_attributes
        response.should redirect_to(Rating.last)
      end
    end
  end

  describe 'GET edit' do
    it 'assigns the requested rating as @rating' do
      @rating = rating
      get :edit, id: @rating.to_param
      expect(assigns :rating).to eq(@rating)
    end
  end

  describe 'PUT update' do
    before :each do
      @rating = rating
      put :update, id: @rating.to_param, rating: {mark: 3}
    end
    it 'redirects to the created rating' do
      response.should redirect_to(Rating.last)
    end

    it 'update mark' do
      expect(@rating.reload.mark).to eq(3)
    end
  end

  describe 'DELETE destroy' do
    it 'destroy the requested rating' do
      @rating = rating
      expect {
        delete :destroy, id: @rating.to_param
      }.to change{Rating.count}.by(-1)
    end
  end
end
