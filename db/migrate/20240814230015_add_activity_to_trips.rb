class AddActivityToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :activity, :string
  end
end
