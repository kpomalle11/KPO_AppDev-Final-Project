class TripsController < ApplicationController
  def index
    matching_trips = Trip.all

    @list_of_trips = matching_trips.order({ :created_at => :desc })

    render({ :template => "trips/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_trips = Trip.where({ :id => the_id })

    @the_trip = matching_trips.at(0)

    render({ :template => "trips/show" })
  end

  def create
    the_trip = Trip.new
    the_trip.owner_id = params.fetch("query_owner_id")
    the_trip.description = params.fetch("query_description")
    the_trip.arrival_date = params.fetch("query_arrival_date")
    the_trip.departure_date = params.fetch("query_departure_date")
    the_trip.title = params.fetch("query_title")
    the_trip.activity_id = params.fetch("query_activity_id")
    the_trip.published = params.fetch("query_published", false)

    if the_trip.valid?
      the_trip.save
      redirect_to("/trips", { :notice => "Trip created successfully." })
    else
      redirect_to("/trips", { :alert => the_trip.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_trip = Trip.where({ :id => the_id }).at(0)

    the_trip.owner_id = params.fetch("query_owner_id")
    the_trip.description = params.fetch("query_description")
    the_trip.arrival_date = params.fetch("query_arrival_date")
    the_trip.departure_date = params.fetch("query_departure_date")
    the_trip.title = params.fetch("query_title")
    the_trip.activity_id = params.fetch("query_activity_id")
    the_trip.published = params.fetch("query_published", false)

    if the_trip.valid?
      the_trip.save
      redirect_to("/trips/#{the_trip.id}", { :notice => "Trip updated successfully."} )
    else
      redirect_to("/trips/#{the_trip.id}", { :alert => the_trip.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_trip = Trip.where({ :id => the_id }).at(0)

    the_trip.destroy

    redirect_to("/trips", { :notice => "Trip deleted successfully."} )
  end
end
