require_dependency 'projects_helper'

module Standup
  module ProjectsHelperPatch

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :project_settings_tabs, :standup_report
      end
    end

    module InstanceMethods

      def project_settings_tabs_with_standup_report
        tabs = project_settings_tabs_without_standup_report
        tabs << {:name => 'standup_reports',
          :action => :manage_project_standup_setting,
          :partial => 'standup_reports/setting_standup',
          :label => 'label_standup'
        } if @project.module_enabled?('standup')
        return tabs
      end

    end

  end
end

ProjectsHelper.send(:include, Standup::ProjectsHelperPatch) unless ProjectsHelper.included_modules.include? Standup::ProjectsHelperPatch


