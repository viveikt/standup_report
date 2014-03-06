require 'redmine'
require_dependency 'standup_projects_helper_patch'

Project.send(:include, ProjectModelPatch )

Redmine::Plugin.register :standup_report do
  name 'Prevas Easy Standup Report plugin'
  author 'Vivek T'
  description 'This is a plugin for creating easy stand-up report everyday'
  version '1.0.0'
  url ''
  author_url 'mailto:Vivek.T <vivek.t@prevas.com>?subject=Standup Report'

  menu :project_menu, :standup_reports, {:controller => "standup_reports", :action => "home"}, :caption => 'Standup', :after => :settings, :param => :project_id, :if => Proc.new { User.current.logged? }

  project_module :standup do
    permission :view_standup, :standup_reports => [:home, :verify]
  end

  settings(:partial => 'standup_settings',
           :default => {
             'standup_last_day_work' => 'What I did in the last day / week',
             'standup_today_work' => 'What I will do today / this week',
             'standup_roadblock' => 'Do you have roadblocks? If you have questions or you need help. Please write your questions or needs here'
          })

end

 begin
  if InstanceCreatorForm.where("instance_name LIKE ?", "%pdprojects%").first.present?
    if ActiveRecord::Base.connection.table_exists? 'non_submission_times'
     nonsubmission_times = NonSubmissionTime.all
     unless nonsubmission_times.empty?
      require 'rufus/scheduler'
      nonsubmission_times.each do |nonsubmission_time|
        hr = nonsubmission_time.hour
        min = nonsubmission_time.min
        current_date = Date.today
        date_with_time = "#{current_date} #{hr}:#{min}:00 +0530".to_time
        new_time = date_with_time.in_time_zone('Stockholm')
        hr = new_time.hour.to_s
        min = new_time.min.to_s
        # Used from redmine_wktime plugin.
        scheduler = Rufus::Scheduler.new
        cronSt = "#{min} #{hr} * * *"
        scheduler.cron cronSt do
          begin
            Rails.logger.info "==========Scheduler Started=========="
            standup_projectsetting_helper = Object.new.extend(StandupProjectSettingsHelper)
            standup_projectsetting_helper.sendNonSubmissionMail(nonsubmission_time.project_id, nonsubmission_time.message)
            Rails.logger.info "==========Scheduler Ended=========="
          rescue Exception => e
            Rails.logger.info "Scheduler failed: #{e.message}"
          end
        end
       end
      end
    end
  end
rescue => e
  logger.error "An error occured.\nException was: #{e.message} ======= #{e.class}" if logger
end
 