class RatingsController < ApplicationController
  before_filter :find_rating, except: [:index, :new, :create]
  before_filter :build_rating_from_params, only: [:create, :update]
  before_filter :set_project, except: [:new, :index]
  before_filter :authorize,   except: [:new, :index]


  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper


  def index
    @project = Project.find params[:project_id]
    @query = RatingQuery.build_from_params params, project: @project, name: '_'

    sort_init(@query.sort_criteria.empty? ? [['created_on', 'desc']] : @query.sort_criteria)
    sort_update(@query.sortable_columns)
    scope = @query.results_scope(order: sort_clause).
      includes(:project, :evaluated, :evaluator, :issue).
      preload(issue: [:project, :tracker, :status, :assigned_to, :priority])

    @entry_count = scope.count
    @entry_pages = Paginator.new @entry_count, per_page_option, params['page']
    @entries = scope.offset(@entry_pages.offset).limit(@entry_pages.per_page).all

    @average_mark = scope.average :mark
  end
  
  def show; end

  def new
    @rating = User.current.centos_evaluations.build
    unless params[:issue_id].blank?
      @rating.issue = Issue.find params[:issue_id]
      @project, @rating.project = @rating.issue.project
      @rating.evaluated = @rating.issue.assigned_to
    end
    @rating.evaluated = User.find params[:user_id] unless params[:user_id].blank?
    authorize
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

    def save_rating(fail_render)
      if @rating.save
        redirect_to rating_path @rating
      else
        render status: 422, action: fail_render
      end
    end

    def build_rating_from_params
      @rating = User.current.centos_evaluations.build if @rating.nil?
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
