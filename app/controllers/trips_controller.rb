class TripsController < ApplicationController
  require 'openai'

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

  def ask_chatgpt
    trip_params = {
      owner_id: params[:query_owner_id],
      description: params[:query_description],
      arrival_date: params[:query_arrival_date],
      departure_date: params[:query_departure_date],
      title: params[:query_title],
      activity_id: params[:query_activity_id],
      published: params[:query_published].present?,
    }

    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

    message_list = [
      {
        "role" => "system",
        "content" => "You are a helpful travel assistant helping the users plan a trip according to their message.  It would be help to suggest activities to do, places to stay, restaurants to go to, and other cool things based on the specific location or surrounding area.  Essentially, build out a trip itinerary for the user based on the message context.",
      },
      {
        "role" => "user",
        "content" => "I am planning a trip with the following details: #{trip_params}. Please provide suggestions and advice.",
      },
    ]

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: message_list,
        max_tokens: 150,
      },
    )

    @chatgpt_response = response.dig("choices", 0, "message", "content")

    # You can either render this on a new page or show it in the current view.
    render plain: @chatgpt_response
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
      redirect_to("/trips/#{the_trip.id}", { :notice => "Trip updated successfully." })
    else
      redirect_to("/trips/#{the_trip.id}", { :alert => the_trip.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_trip = Trip.where({ :id => the_id }).at(0)

    the_trip.destroy

    redirect_to("/trips", { :notice => "Trip deleted successfully." })
  end
end
