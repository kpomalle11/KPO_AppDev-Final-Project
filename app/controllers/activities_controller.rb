class ActivitiesController < ApplicationController
  def index
    matching_activities = Activity.all

    @list_of_activities = matching_activities.order({ :created_at => :desc })

    render({ :template => "activities/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_activities = Activity.where({ :id => the_id })

    @the_activity = matching_activities.at(0)

    render({ :template => "activities/show" })
  end

  def create
    the_activity = Activity.new
    the_activity.activity_name = params.fetch("query_activity_name")
    the_activity.activity_description = params.fetch("query_activity_description")
    the_activity.location = params.fetch("query_location")
    the_activity.day_start_time = params.fetch("query_day_start_time")
    the_activity.day_end_time = params.fetch("query_day_end_time")
    the_activity.trip_id = params.fetch("query_trip_id")

    if the_activity.valid?
      the_activity.save
      redirect_to("/activities", { :notice => "Activity created successfully." })
    else
      redirect_to("/activities", { :alert => the_activity.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_activity = Activity.where({ :id => the_id }).at(0)

    the_activity.activity_name = params.fetch("query_activity_name")
    the_activity.activity_description = params.fetch("query_activity_description")
    the_activity.location = params.fetch("query_location")
    the_activity.day_start_time = params.fetch("query_day_start_time")
    the_activity.day_end_time = params.fetch("query_day_end_time")
    the_activity.trip_id = params.fetch("query_trip_id")

    if the_activity.valid?
      the_activity.save
      redirect_to("/activities/#{the_activity.id}", { :notice => "Activity updated successfully."} )
    else
      redirect_to("/activities/#{the_activity.id}", { :alert => the_activity.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_activity = Activity.where({ :id => the_id }).at(0)

    the_activity.destroy

    redirect_to("/activities", { :notice => "Activity deleted successfully."} )
  end
end
