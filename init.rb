# Hooks
require_dependency 'centos_admin/rating/hooks/issue'

# Patches
require 'centos_admin/rating/patches/user'
require 'centos_admin/rating/patches/issue'
require 'centos_admin/rating/patches/project'

Redmine::Plugin.register :redmine_centosadmin_rating do
  name 'Redmine Centosadmin Rating plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
 
  project_module :centosadmin_rating do
    permission :centos_rate, { 'centos_admin/rating/ratings' => [:new, :create] }
    permission :centos_be_rated, {}
  end
end
