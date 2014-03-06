class AddColumnToMembers < ActiveRecord::Migration

	def self.up
		add_column :members, :standup_report_permission, :boolean, :default => 1
	end

	def self.down
		remove_column :members, :standup_report_permission
	end
end