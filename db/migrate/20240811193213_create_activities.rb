class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :activity_name
      t.text :activity_description
      t.string :location
      t.datetime :day_start_time
      t.datetime :day_end_time
      t.integer :trip_id

      t.timestamps
    end
  end
end
