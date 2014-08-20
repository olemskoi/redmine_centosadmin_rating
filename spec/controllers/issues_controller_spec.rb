require File.dirname(__FILE__) + '/../spec_helper'

describe IssuesController do
  describe 'PUT update' do
    before do
      @project   = create :project
      @evaluated = (create :member, project: @project, role_name: 'Developer').user
      @evaluator = (create :member, project: @project, role_name: 'Manager').user
      @issue     = create :issue,  project: @project, author: @evaluator, assigned_to: @evaluated
      User.current = @evaluator
      @request.session[:user_id] = @evaluator.id
    end

    context 'issue without rating' do
      it 'no rating => no change' do
        expect{
          put :update, id: @issue.id, issue: { description: 'hello' }
        }.not_to change{ @issue.ratings.count }
      end

      it 'with params => create' do
        expect{
          put :update, id: @issue.id, issue: { description: 'hello', rating: { evaluated_id: @evaluated.id, mark: 3 } }
        }.to change{ @issue.ratings.count }.by 1
      end
    end

    context 'issue with rating' do
      before do
        @rating = create :rating, issue: @issue, project: @issue.project, evaluator: @evaluator, evaluated: @evaluated, mark: 1
      end

      it 'no params => no change' do
        expect{
          put :update, id: @issue.id, issue: { description: 'hello' }
        }.not_to change{ @issue.ratings.count }
      end

      it 'empty mark => destroy' do
        expect{
          put :update, id: @issue.id, issue: { rating: { evaluated_id: @evaluated.id, mark: '' } }
        }.to change{ @issue.ratings.count }.by -1
      end

      it 'with params => update' do
        expect{
          put :update, id: @issue.id, issue: { rating: { evaluated_id: @evaluated.id, mark: 4 } }
        }.to change{ @rating.reload.mark }.to 4
      end
    end
  end
end
