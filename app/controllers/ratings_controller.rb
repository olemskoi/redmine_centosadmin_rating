class RatingsController < ApplicationController
  before_filter :find_rating, except: [:index, :new, :create]
  before_filter :build_rating_from_params, only: [:create, :update]
  before_filter :set_project, except: [:new, :index]
  #before_filter :authorize,   expect: [:new, :index]


  def index 
    @ratings = Rating.all
  end
  
  def show; end

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
    save_rating :edit
  end

  def create
    save_rating :new
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

    def save_rating(fail_rednder)
      if @rating.save
        redirect_to rating_path(@rating)
      else
        render status: 422, action: fail_rednder
      end
    end

    def build_rating_from_params
      @rating = Rating.new if @rating.nil?
      @rating.safe_attributes = params[:rating]

    end

    def find_rating
      @rating = Rating.find params[:id]
    rescue ActiveRecord::RecordNotFound
      render_404
    end

    def set_project
      @project = @rating.issue.project
    end

    def authorize; super(params[:controller], params[:action], global = true); end
end
