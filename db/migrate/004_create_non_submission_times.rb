class CreateNonSubmissionTimes < ActiveRecord::Migration
  def change
    create_table :non_submission_times do |t|
    	t.string :hour
      t.string :min
      t.string :sec
      t.integer :project_id
      t.string :user
      t.timestamps
    end
  end
end
