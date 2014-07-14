module Centos::Rating::Hooks
  class Project < Redmine::Hook::ViewListener
    render_on :view_projects_show_sidebar_bottom, partial: 'centos/rating/projects/sidebar_ratings_report_link'
  end
end
