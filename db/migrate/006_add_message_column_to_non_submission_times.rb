class AddMessageColumnToNonSubmissionTimes < ActiveRecord::Migration

	def self.up
		add_column :non_submission_times, :message, :text
	end

	def self.down
		remove_column :non_submission_times, :message
	end
end