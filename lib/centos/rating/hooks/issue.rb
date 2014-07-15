module Centos::Rating::Hooks
  class Issue < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, partial: 'centos/rating/issues/rate'
  end
end
