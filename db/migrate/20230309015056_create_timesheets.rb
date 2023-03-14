class CreateTimesheets < ActiveRecord::Migration[7.0]
  def change
    create_table :timesheets do |t|
      t.timestamp :clock_in
      t.timestamp :clock_out
      t.decimal :sleep_time_in_seconds
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
