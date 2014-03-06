module StandupProjectSettingsHelper

 def sendNonSubmissionMail(project_id, message)
  project = Project.find_by_id(project_id)
  if project.module_enabled?(:standup)
    deadline = Date.today
    #project = Project.find_by_id(project_id)
    login_all = User.active.collect{|a| a.login}.delete_if{|rej| rej.empty?}
    readers = []
    role = Role.find_by_name("Readers")
    role.members.where("project_id = ?", project.id).each do |member|
      user_role_readers_another = MemberRole.find_all_by_member_id(member.id).size
      if user_role_readers_another == 1
        readers << User.find_by_id(member.user_id).login rescue nil if member.standup_report_permission == true
      else
        next
      end
    end
	
    rest_logins =  login_all - readers.collect!{|a| a}.delete_if{|rej| rej.empty?}
    rest_logins = rest_logins.delete_if{|rej| User.find_by_login(rej).members.where("project_id = ?", project.id).first.nil? || User.find_by_login(rej).members.where("project_id = ?", project.id).first.standup_report_permission == false }
    unless (deadline.wday == 6 || deadline.wday == 0)
      rest_logins.each do |user|
        standup_report = StandupReport.where(:user => user, :project_id => project.id, :title => deadline.to_s)
        StandupReportMailer.non_submission_standup_notification(project.id,user,deadline.to_s,message).deliver unless standup_report.present?
      end
    end
  end
 end

end
