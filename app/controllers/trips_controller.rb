class TripsController < ApplicationController
  require "openai"

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

  def user_trips
    matching_trips = Trip.where(owner_id: current_user.id) 
    
    @list_of_my_trips = matching_trips.order(created_at: :desc)

    render(template: "/trips/mytrips")
  end

  
  def add_trip

    render(template: "/trips/addtrip")
    
  end

  def create
    the_trip = Trip.new
    the_trip.owner_id = params.fetch("query_owner_id")
    the_trip.description = params.fetch("query_description")
    the_trip.arrival_date = params.fetch("query_arrival_date")
    the_trip.departure_date = params.fetch("query_departure_date")
    the_trip.title = params.fetch("query_title")
    the_trip.activity = params.fetch("query_activity")
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
      activity: params[:query_activity],
      published: params[:query_published].present?,
    }

    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

    message_list = [
      {
        "role" => "system",
        "content" => "You are a helpful travel assistant helping users plan a trip. Your task is to generate a complete travel itinerary in the form of a JSON object. Only return the JSON object, without any additional text or explanations. The JSON object should include these fields: arrival_date, departure_date, title, activity_id, and description. Please return the response in a JSON format like this:
        {
          \"arrival_date\": \"<arrival_date>\",
          \"departure_date\": \"<departure_date>\",
          \"title\": \"<title>\",
          \"activity\": \"<activity>\",
          \"description\": \"<description>\"
        }.",
      },
      {
        "role" => "user",
        "content" => "I am planning a trip with the following details: #{trip_params}. Please provide suggestions and advice, and return the data in JSON format only.",
      },
    ]

    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: message_list,
        max_tokens: 500,
      },
    )

    response_content = response.dig("choices", 0, "message", "content").strip

    # Attempt to parse the response
    begin
      parsed_response = JSON.parse(response_content)
    rescue JSON::ParserError => e
      # Handle parsing error (for example, log it and inform the user)
      redirect_to(new_trip_path, alert: "There was an error processing your request. Please try again.")
      return
    end

    # Create a new trip using the ChatGPT response
    the_trip = Trip.create!(
      owner_id: trip_params[:owner_id],
      description: parsed_response["description"],
      arrival_date: parsed_response["arrival_date"],
      departure_date: parsed_response["departure_date"],
      title: parsed_response["title"],
      activity: parsed_response["activity"],
      published: false,  # Set to false by default, the user can publish later
    )

    # Redirect to the edit page for the newly created trip
    redirect_to("/trips/#{the_trip.id}/edit", notice: "Trip created based on ChatGPT suggestions. Please review and update.")
  end

  def update
    # Rails.logger.debug "Received params: #{params.inspect}" # Log to see what params are received

    the_trip = Trip.find(params[:path_id])
    # trip_params = trip_params() # Using a method to fetch trip params

    # trip_params = params[:trip] || params

    the_trip.owner_id = params[:query_owner_id]
    the_trip.description = params[:query_description]
    the_trip.arrival_date = params[:query_arrival_date]
    the_trip.departure_date = params[:query_departure_date]
    the_trip.title = params[:query_title]
    the_trip.activity_id = params[:query_activity]
    the_trip.published = params[:query_published]

    if the_trip.valid?
      the_trip.save
      redirect_to("/trips/#{the_trip.id}", { :notice => "Trip updated successfully." })
    else
      redirect_to("/trips/#{the_trip.id}", { :alert => the_trip.errors.full_messages.to_sentence })
    end
  end

  def edit
    @trip = Trip.find(params[:path_id])
  end

  # Redirect back to the form with empty parameters
  def clear_form
    redirect_to new_trip_path
  end

  def destroy
    the_id = params.fetch("path_id")
    the_trip = Trip.where({ :id => the_id }).at(0)

    the_trip.destroy

    redirect_to("/trips", { :notice => "Trip deleted successfully." })
  end
end
