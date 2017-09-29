# Hooks
require_dependency 'centos/rating/hooks/issue'
require_dependency 'centos/rating/hooks/user'

# Patches
require 'centos/rating/patches/user'
require 'centos/rating/patches/issue'
require 'centos/rating/patches/project'
require 'centos/rating/patches/issues_controller'

# Mailers
require_relative 'app/mailers/rating_mailer'

Redmine::Plugin.register :redmine_centosadmin_rating do
  name 'Redmine Centos-admin.ru Rating plugin'
  author 'Southbridge'
  description 'Redmine Centosadmin Rating plugin'
  version '0.1.0'
  url 'https://github.com/olemskoi/redmine_centosadmin_rating'
  author_url 'https://southbridge.io'

  project_module :centosadmin_rating do
    permission :centos_rate, { staff_ratings: [:new, :create, :show, :edit, :update, :destroy] }
    permission :centos_be_rated, {}
    permission :view_staff_ratings, { staff_ratings: [:index, :show] }
  end

  Redmine::Activity.map do |activity|
    activity.register :staff_ratings
  end

  menu :project_menu, :staff_ratings, { controller: 'staff_ratings', action: 'index' }, caption: :rating, param: :project_id

  settings default: { 'must_rate' => false, 'must_status' => 'Closed', 'must_day' => '3' },
           partial: 'centos/rating/settings'
end

ActionDispatch::Callbacks.to_prepare do
  unless Issue.included_modules.include? Centos::Rating::Patches::Issue
    Issue.send :include, Centos::Rating::Patches::Issue
  end

  unless IssuesController.included_modules.include? Centos::Rating::Patches::IssuesController
    IssuesController.send :include, Centos::Rating::Patches::IssuesController
  end

  unless Project.included_modules.include? Centos::Rating::Patches::Project
    Project.send :include, Centos::Rating::Patches::Project
  end

  unless User.included_modules.include? Centos::Rating::Patches::User
    User.send :include, Centos::Rating::Patches::User
  end
end
