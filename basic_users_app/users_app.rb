require 'yaml'

require 'tilt/erubis'
require 'sinatra'
require 'sinatra/reloader'

before do
  @user_info = YAML.load_file("users.yaml")
end

get "/" do
  redirect "/users"
end

get "/users" do
  erb :users
end

get "/:user_name" do
  @user_name = params[:user_name].to_sym
  @email = @user_info[@user_name][:email]
  @interests = @user_info[@user_name][:interests]

  erb :user
end

helpers do
 def count_interests(users)
   users.inject(0) do |sum, (name, user_data)|
     sum + user_data[:interests].size
   end
 end
end
