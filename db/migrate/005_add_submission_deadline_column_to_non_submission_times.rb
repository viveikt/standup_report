class AddSubmissionDeadlineColumnToNonSubmissionTimes < ActiveRecord::Migration

	def self.up
		add_column :non_submission_times, :submission_deadline, :string
	end

	def self.down
		remove_column :non_submission_times, :submission_deadline
	end
end