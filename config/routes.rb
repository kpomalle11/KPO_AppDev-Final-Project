Rails.application.routes.draw do
  devise_for :users

  post "/insert_trip", to: "trips#create"
  post "/ask_chatgpt", to: "trips#ask_chatgpt"

  #homepage

  root to: "trips#index"

  # Routes for the Activity resource:

  # CREATE
  post("/insert_activity", { :controller => "activities", :action => "create" })

  # READ
  get("/activities", { :controller => "activities", :action => "index" })

  get("/activities/:path_id", { :controller => "activities", :action => "show" })

  # UPDATE

  post("/modify_activity/:path_id", { :controller => "activities", :action => "update" })

  # DELETE
  get("/delete_activity/:path_id", { :controller => "activities", :action => "destroy" })

  #------------------------------

  # Routes for the Comment resource:

  # CREATE
  post("/insert_comment", { :controller => "comments", :action => "create" })

  # READ
  get("/comments", { :controller => "comments", :action => "index" })

  get("/comments/:path_id", { :controller => "comments", :action => "show" })

  # UPDATE

  post("/modify_comment/:path_id", { :controller => "comments", :action => "update" })

  # DELETE
  get("/delete_comment/:path_id", { :controller => "comments", :action => "destroy" })

  #------------------------------

  # Routes for the Trip resource:

  # CREATE
  post("/insert_trip", { :controller => "trips", :action => "create" })

  # READ
  get("/trips", { :controller => "trips", :action => "index" })

  get("/trips/mytrips", { :controller => "trips", :action => "user_trips" })

  get("/trips/addtrip", { :controller => "trips", :action => "add_trip" })

  get("/trips/:path_id", { :controller => "trips", :action => "show" })

  # UPDATE
  post("/modify_trip/:path_id", to: "trips#update", as: "modify_trip")
  get("/trips/:path_id/edit", to: "trips#edit", as: "edit_trip")
  get("/clear_trip_form", { :controller => "trips", :action => "clear_form" })

  # post("/modify_trip/:path_id", { :controller => "trips", :action => "update" })
  # get("/trips/:path_id/edit", { :controller => "trips", :action => "edit" })

  # DELETE
  get("/delete_trip/:path_id", { :controller => "trips", :action => "destroy" })

  #------------------------------

end
