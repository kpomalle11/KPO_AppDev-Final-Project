class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.integer :owner_id
      t.text :description
      t.integer :companion_id
      t.date :arrival_date
      t.date :departure_date
      t.string :title
      t.integer :comment_id
      t.text :comments
      t.integer :activity_id
      t.boolean :published

      t.timestamps
    end
  end
end
