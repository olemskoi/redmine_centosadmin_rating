module CentosAdmin::Rating::Hooks
  class Issue < Redmine::Hook::ViewListener
    render_on :view_issues_show_description_bottom, partial: 'centos_admin/rating/issues/rate'
  end
end
