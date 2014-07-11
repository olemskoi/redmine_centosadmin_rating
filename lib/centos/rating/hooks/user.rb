module Centos::Rating::Hooks
  class User < Redmine::Hook::ViewListener
    render_on :view_account_left_bottom, partial: 'centos/rating/users/rating'
  end
end
