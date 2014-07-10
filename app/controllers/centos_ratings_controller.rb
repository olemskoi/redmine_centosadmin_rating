class CentosRatingsController < ApplicationController
  before_filter :do_things

  def show
  end

  def new
  end

  def create
    if @rating.save
      redirect_to rating_path @rating
    else
      render action: 'new'
    end
  end

  def destroy
    @rating.destroy
    if @rating.issue
      redirect_to issue_path @rating.issue
    else
      redirect_to user_path @rating.evaluated
    end
  end

  protected

  def do_things
    if params[:id]
      @rating = CentosRating.find params[:id]

    elsif params[:rating]
      @rating = CentosRating.new(params[:rating].merge({ evaluator: User.current }))

    else
      @rating = CentosRating.new
      if params[:issue_id]
        @rating.issue = Issue.find params[:issue_id]
        @rating.project = @rating.issue.project
        @rating.evaluated = @rating.issue.assigned_to
      elsif params[:user_id]
        @rating.evaluated = User.find params[:user_id]
      end
    end

    @project = @rating.project
    authorize params[:controller], params[:action], true
  end
end
