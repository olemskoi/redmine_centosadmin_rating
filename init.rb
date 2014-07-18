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
  name 'Redmine Centosadmin Rating plugin'
  author 'CentosAdmin'
  description 'Redmine Centosadmin Rating plugin'
  version '0.1.0'
  url 'https://github.com/olemskoi/redmine_centosadmin_rating'
  author_url 'http://centos-admin.ru/'
 
  project_module :centosadmin_rating do
    permission :centos_rate, { ratings: [:new, :create, :show, :edit, :update, :destroy] }
    permission :centos_be_rated, {}
    permission :view_ratings, { ratings: [:index, :show] }
  end

  Redmine::Activity.map do |activity|
    activity.register :ratings
  end

  menu :project_menu, :ratings, { controller: 'ratings', action: 'index' }, caption: :rating, param: :project_id

  settings default: { 'must_rate' => false, 'must_status' => 'Closed', 'must_day' => '3' },
           partial: 'centos/rating/settings'
end
