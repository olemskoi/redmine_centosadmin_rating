require File.dirname(__FILE__) + '/../spec_helper'

describe CentosRatingsController do
  fixtures :users, :issues

  let(:evaluated) {User.first}
  let(:evaluator)  {User.last}

  describe 'GET index' do
    before :each do
      @ratings = [FactoryGirl.create(:centos_rating, evaluated: evaluated, evaluator: evaluator)]
    end

    it 'assigns all ratings as @ratings' do
      get :index
      expect(assigns(:ratings)).to eq(@ratings)
    end
  end

end