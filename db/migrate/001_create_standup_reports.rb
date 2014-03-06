class CreateStandupReports < ActiveRecord::Migration
  def change
    create_table :standup_reports do |t|
      t.text :prev_day
      t.text :current_day
      t.text :roadblocks
      t.string :title
      t.string :user
      t.timestamps
    end
  end
end
