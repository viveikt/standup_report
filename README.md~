Standup Report 
==============

Standup Report Plugin For Redmine : Plugin uses the idea of Daily standup meetings which is usually held between the team to update the current status. This plugin can be used to add the daily status report of what work was done the previous day, what will you be doing today and if there are any roadblocks. Configurable mailers which send non submission reports to users who have not filled in their standup report. 

Installation Procedure:
_______________________ 

1. git clone https://github.com/viveikt/standup_report.git standup_report 

2. Database Migration:

2.1. For Redmine 1.x:

rake db:migrate_plugins RAILS_ENV=production

2.2. For Redmine 2.x:

rake redmine:plugins:migrate RAILS_ENV=production

3. Restart Redmine

You should now be able to see the plugin list in Administration -> Plugins and configure the newly installed plugin (if the plugin requires to be configured).

==> The plugin can be enabled in the projects modules. Once enabled it will be pop up as a link in the menu. 

Uninstalling the plugin :
_________________________

1. Downgrade your database (make a db backup before):

1.1. For Redmine 1.x:

rake db:migrate:plugin NAME=standup_report VERSION=0 RAILS_ENV=production

1.2. For Redmine 2.x:

rake redmine:plugins:migrate NAME=standup_report VERSION=0 RAILS_ENV=production

2. Remove your plugin from the plugins folder: #{RAILS_ROOT}/plugins (Redmine 2.x) or #{RAILS_ROOT}/vendor/plugins (Redmine 1.x)..

3. Restart Redmine

