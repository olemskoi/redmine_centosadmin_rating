class CentosRatingsController < ApplicationController
  #before_filter :authorize
  before_filter :find_rating, expect: [:index, :new]


  def index 
    @ratings = CentosRating.all
  end
  
  def show;  end

  def new
    @rating = User.current.centos_evaluations.build
    unless params[:issue_id].blank?
      @rating.issue = Issue.find params[:issue_id]
      @rating.project = @rating.issue.project
      @rating.evaluated = @rating.issue.assigned_to
    end
    @rating.evaluated = User.find params[:user_id] unless params[:user_id].blank?
  end

  def edit; end

  def update
    update_rating :edit
  end

  def create
    @rating = User.current.centos_evaluations.build
    update_rating :new
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
  def find_rating
    @rating = CentosRating.find params[:id]
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def update_rating(fail_rednder)
    @rating.safe_attributes = params[:centos_rating]
    if @rating.save
      redirect_to centos_rating_path(@rating)
    else
      render status: 422, action: fail_rednder
    end
  end
end
