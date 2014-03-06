module StandupReportsHelper

 def options_for_period_select(value)
  options_for_select([[l(:label_this_week), 'current_week'],
					 [l(:label_last_week), 'last_week'],
					 [l(:label_this_month), 'current_month'],
					 [l(:label_last_month), 'last_month']],
					 value.blank? ? 'current_week' : value)
 end

# Retrieves the date range based on predefined ranges or specific from/to param dates from wktime plugin
  def retrieve_date_range
    @free_period = false
    @from, @to = nil, nil

    if params[:period_type] == '1' || (params[:period_type].nil? && !params[:period].nil?)
      case params[:period].to_s
      when 'today'
        @from = @to = Date.today
      when 'yesterday'
        @from = @to = Date.today - 1
      when 'current_week'
        @from = getStartDay(Date.today - (Date.today.cwday - 1)%7)
        @to = @from + 6
      when 'last_week'
        @from =getStartDay(Date.today - 7 - (Date.today.cwday - 1)%7)
      @to = @from + 6
      when '7_days'
        @from = Date.today - 7
        @to = Date.today
      when 'current_month'
        @from = Date.civil(Date.today.year, Date.today.month, 1)
        @to = (@from >> 1) - 1
      when 'last_month'
        @from = Date.civil(Date.today.year, Date.today.month, 1) << 1
        @to = (@from >> 1) - 1
      when '30_days'
        @from = Date.today - 30
        @to = Date.today
      when 'current_year'
        @from = Date.civil(Date.today.year, 1, 1)
        @to = Date.civil(Date.today.year, 12, 31)
      end
    elsif params[:period_type] == '2' || (params[:period_type].nil? && (!params[:from].nil? || !params[:to].nil?))
      begin; @from = params[:from].to_s.to_date unless params[:from].blank?; rescue; end
      begin; @to = params[:to].to_s.to_date unless params[:to].blank?; rescue; end
      @free_period = true
    else
      # default
    # 'this_week'
        @from = getStartDay(Date.today - (Date.today.cwday - 1)%7)
        @to = @from + 6
    end

    @from, @to = @to, @from if @from && @to && @from > @to

  end

  #change the date to first day of week
  def getStartDay(date)
    startOfWeek = getStartOfWeek
    #Martin Dube contribution: 'start of the week' configuration
    unless date.nil?
      #the day of calendar week (0-6, Sunday is 0)
      dayfirst_diff = (date.wday+7) - (startOfWeek)
      date -= (dayfirst_diff%7)
    end
    date
  end

  #Code snippet taken from application_helper.rb  - include_calendar_headers_tags method
  def getStartOfWeek
    start_of_week = Setting.start_of_week
        start_of_week = l(:general_first_day_of_week, :default => '1') if start_of_week.blank?
    start_of_week = start_of_week.to_i % 7
  end

  def getEndDay(date)
    start_of_week = getStartOfWeek
    #Martin Dube contribution: 'start of the week' configuration
    unless date.nil?
      daylast_diff = (6 + start_of_week) - date.wday
      date += (daylast_diff%7)
    end
    date
  end

  def standup_id_for_user(standup_report)
    standup_report.id
  end

end
