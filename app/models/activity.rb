# == Schema Information
#
# Table name: activities
#
#  id                   :bigint           not null, primary key
#  activity_description :text
#  activity_name        :string
#  day_end_time         :datetime
#  day_start_time       :datetime
#  location             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  trip_id              :integer
#
class Activity < ApplicationRecord
  validates(:trip_id, presence: true)
end
