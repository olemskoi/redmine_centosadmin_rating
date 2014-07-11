# Hooks
require_dependency 'centos/rating/hooks/issue'
require_dependency 'centos/rating/hooks/user'

# Patches
require 'centos/rating/patches/user'
require 'centos/rating/patches/issue'
require 'centos/rating/patches/project'

Redmine::Plugin.register :redmine_centosadmin_rating do
  name 'Redmine Centosadmin Rating plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
 
  project_module :centosadmin_rating do
    permission :centos_rate, { centos_ratings: [:new, :create, :show] }
    permission :centos_be_rated, {}
  end

  Redmine::Activity.map do |activity|
    activity.register :ratings
  end
end
