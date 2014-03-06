class AddProjectIdToStandupReports < ActiveRecord::Migration

	def self.up
		add_column :standup_reports, :project_id, :integer
	end

	def self.down
		remove_column :standup_reports, :project_id
	end
end