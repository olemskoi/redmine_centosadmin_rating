require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  describe '.rating' do
    before :each do
      @project_1   = create :project
      @project_2   = create :project
      @user = (create :member, project: @project_1, role_name: 'Developer').user
      @evaluator = (create :member, project: @project_1, role_name: 'Manager').user
      @issue_1   =  create :issue,  project: @project_1, author: @evaluator, assigned_to: @user
      @issue_2   =  create :issue,  project: @project_2, author: @evaluator, assigned_to: @user
      @ratings = [create(:rating, evaluated: @user, evaluator: @evaluator, issue: @issue_1),
                  create(:rating, evaluated: @user, evaluator: @evaluator, issue: @issue_2),
                  create(:rating, evaluated: @user, evaluator: @evaluator, issue: @issue_1, created_on: (Date.today - 3))]
    end
    describe 'without options' do
      it 'returns average mark for user by all projects and all time' do
        expect(@user.rating).to eq((@ratings.inject(0){ |sum, n| sum + n.mark }) / @ratings.size)
      end
    end

    it 'returns average mark for user between options[:date_from] and options[:date_to]' do
      expect(@user.rating({date_from: Date.today - 3, date_to: Date.today - 1})).to eq(@ratings.last.mark)
    end

    it 'returns average mark for user between only in the specific project' do
      expect(@user.rating({project_id: @issue_1.project_id})).to eq((@ratings[0].mark + @ratings[2].mark) / 2)
    end
  end
end