desc "Fill the database tables with some sample data"
require "faker"

task({ :sample_data => :environment }) do
  puts "Sample data task running"

  # Reset primary key sequences for each table
  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end

  if Rails.env.development?
    User.destroy_all
    Trip.destroy_all
    Comment.destroy_all
    Activity.destroy_all
  end

  usernames = ["alice", "bob", "carol", "dave", "eve"]

  users = usernames.map do |username|
    User.create!(
      email: "#{username}@example.com",
      password: "password",
    )
  end

  # Create Trips
  trips = [
    { title: "Summer Vacation", description: "A week-long summer trip to the beach.", arrival_date: "2024-08-01", departure_date: "2024-08-08", published: true, owner_id: User.first.id },
    { title: "Skiing Adventure", description: "A weekend trip to the mountains for skiing.", arrival_date: "2024-12-15", departure_date: "2024-12-18", published: false, owner_id: User.second.id },
    { title: "City Tour", description: "Exploring the historic sites of the city.", arrival_date: "2024-10-10", departure_date: "2024-10-12", published: true, owner_id: User.third.id },
    { title: "Desert Safari", description: "An exciting adventure in the desert.", arrival_date: "2024-09-05", departure_date: "2024-09-07", published: true, owner_id: User.fourth.id },
    { title: "Cultural Festival", description: "A weekend experiencing local culture and traditions.", arrival_date: "2024-11-20", departure_date: "2024-11-22", published: false, owner_id: User.fifth.id },
  ]

  trips.each do |trip_data|
    Trip.create!(trip_data)
  end

  # Create Activities
  activities = [
    { activity_name: "Beach Volleyball", activity_description: "Playing volleyball at the beach.", day_start_time: "2024-08-02 10:00:00", day_end_time: "2024-08-02 12:00:00", location: "Beachfront", trip_id: Trip.first.id },
    { activity_name: "Mountain Hiking", activity_description: "Hiking up the mountain trails.", day_start_time: "2024-12-16 09:00:00", day_end_time: "2024-12-16 14:00:00", location: "Mountain Base", trip_id: Trip.second.id },
    { activity_name: "Museum Visit", activity_description: 'A tour of the city\'s history museum.', day_start_time: "2024-10-11 11:00:00", day_end_time: "2024-10-11 13:00:00", location: "City Center", trip_id: Trip.third.id },
    { activity_name: "Dune Bashing", activity_description: "Off-road driving in the desert.", day_start_time: "2024-09-05 14:00:00", day_end_time: "2024-09-05 16:00:00", location: "Desert", trip_id: Trip.fourth.id },
    { activity_name: "Traditional Dance Performance", activity_description: "Watching a traditional dance performance.", day_start_time: "2024-11-21 18:00:00", day_end_time: "2024-11-21 19:00:00", location: "Cultural Center", trip_id: Trip.fifth.id },
    { activity_name: "Snorkeling", activity_description: "Exploring marine life underwater.", day_start_time: "2024-08-03 09:00:00", day_end_time: "2024-08-03 11:00:00", location: "Coral Reef", trip_id: Trip.first.id },
    { activity_name: "Ski Lessons", activity_description: "Learning how to ski.", day_start_time: "2024-12-17 10:00:00", day_end_time: "2024-12-17 12:00:00", location: "Ski Resort", trip_id: Trip.second.id },
  ]

  activities.each do |activity_data|
    Activity.create!(activity_data)
  end

  # Create Comments
  comments = [
    { content: "This trip was amazing! The beach volleyball was so much fun.", trip_id: Trip.first.id, user_id: User.first.id },
    { content: "I can’t wait to go skiing again next year!", trip_id: Trip.second.id, user_id: User.second.id },
    { content: "The museum tour was very informative. Learned a lot!", trip_id: Trip.third.id, user_id: User.third.id },
    { content: "Dune bashing was such an adrenaline rush!", trip_id: Trip.fourth.id, user_id: User.fourth.id },
    { content: "The cultural festival was a unique experience.", trip_id: Trip.fifth.id, user_id: User.fifth.id },
    { content: "Snorkeling was breathtaking, literally and figuratively!", trip_id: Trip.first.id, user_id: User.second.id },
    { content: "The ski lessons were worth it, I finally learned to ski!", trip_id: Trip.second.id, user_id: User.third.id },
  ]

  comments.each do |comment_data|
    Comment.create!(comment_data)
  end

  puts "Created #{User.count} users, #{Trip.count} trips, #{Activity.count} activities, and #{Comment.count} comments."
end
