module CentosAdmin::Rating
  class RatingsController < ApplicationController
    before_filter :find_project, :authorize
    before_filter :find_rating, only: [:show, :edit, :destroy]

    def index
    end

    def show
    end

    def new
    end

    def create
    end
    
    def edit
    end

    def destroy
      @rating.destroy
    end

    protected

    def find_project
      @project = Project.find params[:project_id]
    end

    def find_rating
    end
  end
end
