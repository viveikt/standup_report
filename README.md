Standup Report 
==============

Standup Report Plugin Redmine

Installation Procedure: 

1. git clone https://github.com/viveikt/standup_report.git standup_report 

2. Database Migration:

2.1. For Redmine 1.x:

rake db:migrate_plugins RAILS_ENV=production

2.2. For Redmine 2.x:

rake redmine:plugins:migrate RAILS_ENV=production

3. Restart Redmine

You should now be able to see the plugin list in Administration -> Plugins and configure the newly installed plugin (if the plugin requires to be configured).


Uninstalling the plugin

1. Downgrade your database (make a db backup before):

1.1. For Redmine 1.x:

rake db:migrate:plugin NAME=standup_report VERSION=0 RAILS_ENV=production

1.2. For Redmine 2.x:

rake redmine:plugins:migrate NAME=standup_report VERSION=0 RAILS_ENV=production

2. Remove your plugin from the plugins folder: #{RAILS_ROOT}/plugins (Redmine 2.x) or #{RAILS_ROOT}/vendor/plugins (Redmine 1.x)..

3. Restart Redmine

