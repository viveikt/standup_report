require 'mailer'
class StandupReportMailer < Mailer

 def non_submission_standup_notification(project_id,user,deadline,message)
  @user = User.find_by_login(user)
  project = Project.find_by_id(project_id)
  subject = "#{l(:label_standup_nonsub_mail_subject)}" + " " + deadline
  @body = !message.empty? ? message : "Non submission standup notification"
  @standup_url = "#{Setting['protocol']}://#{Setting['host_name']}/projects/#{project.identifier}/standup_reports/verify?selected_date=#{deadline}"
  mail(:from => Setting['mail_from'] ,:to => @user.mail, :subject => subject)
 end

end