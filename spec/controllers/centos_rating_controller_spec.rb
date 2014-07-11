require File.dirname(__FILE__) + '/../spec_helper'

describe CentosRatingsController do
  fixtures :users, :issues

  let(:evaluated) {User.first}
  let(:evaluator) {User.last}

  let(:valid_attributes) do
    {evaluated_id: User.first.id, evaluator_id: User.last.id, mark: 1, comments: 'ok', issue_id: Issue.first.id}
  end

  describe 'GET index' do
    before :each do
      @ratings = [create(:centos_rating, evaluated: evaluated, evaluator: evaluator)]
    end

    it 'assigns all ratings as @ratings' do
      get :index
      expect(assigns(:ratings)).to eq(@ratings)
    end
  end

  describe 'GET show' do
    before :each do
      @rating = create(:centos_rating, evaluated: evaluated, evaluator: evaluator)
      get :show, id: @rating
    end

    it 'assigns rating as @rating' do
      expect(assigns :rating).to eq(@rating)
    end
  end

  describe 'GET new' do
    it 'assigns a new rating as @raiting' do
      get :new
      assigns(:rating).should be_a_new(CentosRating)
    end

    describe 'as subresource of issue' do
      before :each do
        @issue = Issue.first
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
        @user = User.first
        get :new, user_id: @user
      end

      it 'set evaluated as @user' do
        expect(assigns(:rating).evaluated).to eq(@user)
      end
    end
  end

  describe 'POST create' do
    describe 'with valid attributes' do
      before :all do
        User.current = evaluated
      end

      it 'creates a new CentosRating' do
        expect {
          post :create, centos_rating: valid_attributes
        }.to change{CentosRating.count}.by(1)
      end
      it 'assigns a newly created rating as @rating' do
        post :create, centos_rating: valid_attributes
        expect(assigns :rating).to be_a(CentosRating)
        expect(assigns :rating).to be_persisted
      end

      it 'redirects to the created rating' do
        post :create, centos_rating: valid_attributes
        response.should redirect_to(CentosRating.last)
      end
    end
  end
end