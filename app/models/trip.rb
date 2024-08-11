# == Schema Information
#
# Table name: trips
#
#  id             :bigint           not null, primary key
#  arrival_date   :date
#  comments       :text
#  departure_date :date
#  description    :text
#  published      :boolean
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  activity_id    :integer
#  comment_id     :integer
#  companion_id   :integer
#  owner_id       :integer
#
class Trip < ApplicationRecord
  validates(:owner_id, presence: true)
  validates(:title, uniqueness: true)
end
