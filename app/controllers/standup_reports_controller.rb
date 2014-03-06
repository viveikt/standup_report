# encoding: UTF-8
class StandupReportsController < ApplicationController
  unloadable

  include StandupReportsHelper

  before_filter :require_login
  before_filter :all_users_except_readers_role, :only => [:home, :new, :edit, :verify, :report]
  before_filter :check_for_current_date, :only => [:new, :edit, :verify, :home]
  before_filter :check_for_start_date, :only => [:new, :edit, :verify]

  def home
    @current_date = Time.now.strftime("%Y-%m-%d")
    if !params[:selected_date].nil?
      @selected_date = Date.parse params[:selected_date]
    else
      @selected_date = @current_date
    end
    retrieve_date_range
    @standup_data = StandupReport.where('title =? AND user =? AND project_id =? ',@selected_date, User.current.login, @project.id)
    @standup_reported_users = StandupReport.where('title =? AND project_id =? ',@selected_date, @project.id)
  end

  def new
    if @rest_logins.include?(User.current.login)
  	 @standup_report = StandupReport.new
    else
     redirect_to home_project_standup_reports_path(:project_id => @project.identifier)
    end
  end

  def create
    project = Project.find_by_identifier(params[:project_id])
    @standup_report = project.standup_reports.new(params[:standup_report])
    if @standup_report.save
      flash[:notice] = l(:notice_successful_added)
      redirect_to "/projects/#{params[:project_id]}/standup_reports/home?selected_date=#{@standup_report.title}"
    else
      render :new
    end
  end

  def edit
    if @rest_logins.include?(User.current.login)
      @standup_report = StandupReport.find(params[:id])
    else
      redirect_to home_project_standup_reports_path(:project_id => @project.identifier)
    end
  end

  def update
    @standup_report = StandupReport.find(params[:id])
    if @standup_report.update_attributes(params[:standup_report])
      flash[:notice] = l(:notice_successful_updated)
      redirect_to "/projects/#{params[:project_id]}/standup_reports/home?selected_date=#{@standup_report.title}"
    else
      render 'edit'
    end
  end

  def show
    @current_date = Time.now.strftime("%Y-%m-%d")
    if !params[:selected_date].nil?
      @selected_date = Date.parse params[:selected_date]
    else
      @selected_date = @current_date 
    end
    @standup_report = StandupReport.find(params[:id])
    @project = Project.find_by_id(@standup_report.project_id)
    @user = User.find_by_login(@standup_report.user)
  end

  def verify
    project = Project.find_by_identifier(params[:project_id])
    @verify = StandupReport.where('title =? AND user =? AND project_id =?',params[:selected_date],User.current.login, project.id)
    @verify.each do |a| @id=a.id end
    if @verify.present?
      redirect_to "/projects/#{params[:project_id]}/standup_reports/#{@id}/edit?selected_date=#{params[:selected_date]}"
    else
      redirect_to "/projects/#{params[:project_id]}/standup_reports/new?selected_date=#{params[:selected_date]}"
    end
  end

  def index
    @project = Project.find_by_identifier(params[:project_id])
    redirect_to :controller => 'projects', :action => 'settings', :id => @project,
                :tab => 'standup_reports'
  end

  def report
    @project = Project.find_by_identifier(params[:project_id])
    retrieve_date_range
    #@from = getStartDay(@from)
    #@to = getEndDay(@to)
    if params[:user_id].empty?
      @standup_reports = get_report_from_all_users(@project, @rest_logins, @from, @to)
    else
      @user = User.find_by_id(params[:user_id].to_i)
      @standup_reports = @project.standup_reports.where(:user => @user.login, :title => (@from..@to) )
      @standup_reports.sort! {|a,b| a.title <=> b.title}
    end
  end

  def tooltip
    users = StandupReport.find(params[:standup_id])
    respond_to do |format|
      format.html { render(:partial => "tooltip", :object => users) }
    end
  end

  private

  def all_users_except_readers_role
    users_as_readers = []
    @project = Project.find_by_identifier(params[:project_id])
    @login_all = User.active.collect{|a| a.login}.delete_if{|rej| rej.empty?}
    role = Role.find_by_name("Readers")
    role.members.where("project_id = ?", @project.id).each do |member|
      user_role_readers_another = MemberRole.find_all_by_member_id(member.id)
      count = 0
      user_role_readers_another.each do |member_by_role|
        if member_by_role.role_id == role.id
          count += 1
        end
      end
      if count == user_role_readers_another.size
        users_as_readers << User.find_by_id(member.user_id).login rescue nil if member.standup_report_permission == true
      else
        next
      end
    end
    @rest_logins = @login_all - users_as_readers.collect!{|a| a}.delete_if{|rej| rej.empty?}
    @rest_logins.delete_if{|rej| User.find_by_login(rej).members.where("project_id = ?", @project.id).first.nil? || User.find_by_login(rej).members.where("project_id = ?", @project.id).first.standup_report_permission == false }
    if params['action'] == "home"
      @users_to_select = []
      @rest_logins.each do |login|
        @users_to_select << User.find_by_login(login)
      end
      @users_to_select.sort! {|a,b| a.firstname <=> b.firstname}
    end
  end

  def check_for_current_date
    if params[:selected_date].present? && params[:selected_date].to_date > Date.today
      if params[:action] == "home"
        flash[:error] = "Cannot view future report."
      else
        flash[:error] = "Cannot write Stand-up report for future date."
      end
      redirect_to home_project_standup_reports_path(:project_id => @project.identifier)
    end
  end

  def check_for_start_date
    unless params[:selected_date].present?
      flash[:error] = "Please select date before adding/editing Standup-report."
      redirect_to "/projects/#{params[:project_id]}/standup_reports/home"
    end
  end

  def get_report_from_all_users(project, logins, from, to)
    hash = {}
    logins.each do |login|
      hash[login] = project.standup_reports.where(:user => login, :title => from..to )
    end
    hash
  end

end