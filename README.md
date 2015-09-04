Redmine Rating
==========================


##Installation
Clone repository to your redmine/plugins directory
```
git clone git://github.com/olemskoi/redmine_centosadmin_rating.git
```

Install dependencies
```
bundle install
```

Run migration
```
rake redmine:plugins:migrate
```

To activate the notification of need to evaluate the closed tasks, run
```
cd /redmine_path && bundle exec whenever -i redmine_centosadmin_rating -f plugins/redmine_centosadmin_rating/config/schedule.rb
```

For more information about whenever, see - https://github.com/javan/whenever

Restart redmine

##Configuration 
To activate notifications:

1. go to redmine_host/settings/plugin/redmine_centosadmin_rating.
2. enable notifications.
3. select issue's status.
4. set notice day.

##Running Tests
```
cd /redmine_path/plugins/redmine_centosadmin_rating
bundle exec rspec spec
```


## Sponsors

Work on this plugin was fully funded by [centos-admin.ru](http://centos-admin.ru)

## Developers

Developed by [kernel web](http://kerweb.ru/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

