class RemoveCompanionIdCommentIdAndCommentsFromTrips < ActiveRecord::Migration[7.1]
  def change
    remove_column :trips, :companion_id, :integer
    remove_column :trips, :comment_id, :integer
    remove_column :trips, :comments, :text
  end
end
