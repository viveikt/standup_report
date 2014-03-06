class StandupProjectSettingsController < ApplicationController
  unloadable

  before_filter :require_login
  before_filter :all_users_ids_except_readers

  def standup_setting
  	checked_ids = params[:user][:user_id]
    unchecked_ids = @rest_ids - params[:user][:user_id]
    unless unchecked_ids.empty? 
      unchecked_ids.each do |id|
  		  member = Member.where("user_id = ? AND project_id = ?", id.to_i, @project.id ).first
        if member.present? 
          member.standup_report_permission = 0
          member.save
        end
  	 end
    end
    unless checked_ids.empty? 
      checked_ids.each do |id|
        member = Member.where("user_id = ? AND project_id = ?", id.to_i, @project.id ).first
        if member.present? 
          member.standup_report_permission = 1
          member.save
        end
      end
    end
    user_send_status_report = []
    standup_reports = StandupReport.where("project_id =?", @project.id)
    unless standup_reports.empty?
      standup_reports.each do |standup_report|
        user_send_status_report << standup_report.user
      end
    end
    user_not_send_status_report = @rest_logins - user_send_status_report

    non_submission_time = NonSubmissionTime.where("project_id = ?", @project.id).first
    unless non_submission_time.present?
      set_non_submission_time = NonSubmissionTime.new(:submission_deadline => params[:settings]['standup_submission_deadline'], :hour => params[:settings]['standup_nonsub_hr'],
                                    :min => params[:settings]['standup_nonsub_min'], :message => params[:settings]['standup_nonsub_mail_message'])
      @project.non_submission_time = set_non_submission_time
      set_non_submission_time.user = User.current.login
      set_non_submission_time.save
    else
      non_submission_time.update_attributes(:submission_deadline => params[:settings]['standup_submission_deadline'], :hour => params[:settings]['standup_nonsub_hr'],
                                    :min => params[:settings]['standup_nonsub_min'], :message => params[:settings]['standup_nonsub_mail_message'], :user => User.current.login)
    end
    system("touch #{Rails.root}/tmp/restart.txt")
    flash[:notice] = l(:notice_successful_save)
  	redirect_to :controller => 'projects', :action => 'settings', :id => @project,
                :tab => 'standup_reports'
  end

  private

  def all_users_ids_except_readers
    user_as_readers = []
    @rest_ids = []
    @project = Project.find_by_identifier(params[:project_id]) if params[:project_id].present?
    @login_all = User.active.collect{|a| a.login}.delete_if{|rej| rej.empty?}
    role = Role.find_by_name("Readers")
    role.members.where("project_id = ?", @project.id).each do |member|
      user_role_readers_another = MemberRole.find_all_by_member_id(member.id).size
      if user_role_readers_another == 1
        user_as_readers << User.find(member.user_id).login rescue nil if member.standup_report_permission == true
      else
        next
      end
    end
    @rest_logins = @login_all - user_as_readers.collect!{|a| a}.delete_if{|rej| rej.empty?}
    @rest_logins.delete_if{|rej| User.find_by_login(rej).members.where("project_id = ?", @project.id).first.nil? }
    @rest_logins.each do |login|
    	@rest_ids << User.find_by_login(login).id.to_s
    end
  end

end
