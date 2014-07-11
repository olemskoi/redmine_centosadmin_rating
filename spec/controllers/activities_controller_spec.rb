require File.dirname(__FILE__) + '/../spec_helper'

describe ActivitiesController do
  fixtures :users, :issues, :projects

  let(:evaluated) {User.first}
  let(:evaluator) {User.last}

  describe 'GET index' do
    before :each do
      @rating = create(:centos_rating, evaluated: evaluated, evaluator: evaluator)
    end

    it 'events include event about the created rating' do
      get :index
      expect(assigns(:events_by_day).first).to include(@rating)
    end
  end

end