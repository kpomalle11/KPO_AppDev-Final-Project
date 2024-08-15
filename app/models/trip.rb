# == Schema Information
#
# Table name: trips
#
#  id             :bigint           not null, primary key
#  activity       :string
#  arrival_date   :date
#  departure_date :date
#  description    :text
#  published      :boolean
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  activity_id    :integer
#  owner_id       :integer
#
class Trip < ApplicationRecord
  validates(:owner_id, presence: true)
  validates(:title, uniqueness: true)

  belongs_to :owner, required: true, class_name: "User", foreign_key: "owner_id"

  has_many  :activities, class_name: "Activity", foreign_key: "trip_id", dependent: :destroy

  has_many  :trip_comments, class_name: "Comment", foreign_key: "trip_id", dependent: :destroy

end
