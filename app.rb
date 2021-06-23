require "pry"
require "pry-byebug"
require "sinatra"
require "sinatra/reloader"
require_relative "lib/contact.rb"
require_relative "lib/address.rb"

configure do
  enable :sessions  #Enable sessions in the application so we can persist data between requests. 
  set :session_secret, 'secret'
end
before do 
  session[:contacts] ||= []
end


get "/" do 
  redirect "/home"
end

# View list of contacts
get "/home" do
  @contacts = session[:contacts]
  erb(:index)
end

# Render the new Contact Form
get "/home/create_contact" do 
  erb(:create)
end

post "/contact/delete/:id" do 
  
end

helpers do 
  def add_address(street_1, street_2, city, state, zipcode)
    address = Address.new
    address.street_1 = street_1
    address.street_2 = street_2
    address.city = city
    address.state = state
    address.zipcode = zipcode
    address
  end
end 


post "/create_contact" do 
  address = add_address(params[:street_1], params[:street_2], params[:city], params[:state], params[:zipcode])
  session[:contacts] << Contact.new(first: params[:first], last: params[:last], phone: params[:phone], email: params[:email], address: address)
  @contacts = session[:contacts] 
  redirect "/home"
end

get "/contact/edit" do 

end

post "/contact/edit" do 

end

