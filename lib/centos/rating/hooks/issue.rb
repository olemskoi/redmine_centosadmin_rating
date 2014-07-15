module Centos::Rating::Hooks
  class Issue < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, partial: 'centos/rating/issues/rate'
    render_on :view_issues_form_details_bottom, partial: 'centos/rating/issues/form'
  end
end
