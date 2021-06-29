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

helpers do 
  def add_address(street_1, street_2, city, state, zipcode)
    address = Address.new
    address.street_1 = street_1.split.map(&:capitalize).join(" ")
    address.street_2 = street_2
    address.city = city
    address.state = state
    address.zipcode = zipcode
    address
  end
  
  def load_contacts(id)
    #binding.pry
    contact = session[:contacts].find { |contact| contact.id == id }
    #binding.pry
    session[:error] = "The specified contact was not found."
    return contact if id
    redirect "/home"
  end

  def update_contact(contact, params)
    contact.first = params[:first]
    contact.last = params[:last]
    contact.address.street_1 = params[:street_1]
    contact.address.street_2 = params[:street_2]
    contact.address.city = params[:city]
    contact.address.state = params[:state]
    contact.address.zipcode = params[:zipcode]
    contact.email = params[:email]
    contact.phone = params[:phone]
    contact
  end
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

# Create new contact
post "/create_contact" do 
  address = add_address(params[:street_1], params[:street_2], params[:city], params[:state], params[:zipcode])
  options = { phone: params[:phone], email: params[:email]}
  options.delete_if { |_, v| v.empty? }
  session[:contacts] << Contact.new(first: params[:first], last: params[:last], address: address, **options)
  @contacts = session[:contacts] 
  redirect "/home"
end

# Render edit view 
get "/contact/:id/edit" do 
  @id = params[:id].to_i
  @contact = load_contacts(@id)
  erb(:edit_contact, layout: :layout)
end

# edit an existing contact
post "/contact/:id/edit" do 
  @id = params[:id].to_i
  contact = load_contacts(@id)
  @contact = update_contact(contact, params)
  # binding.pry
  redirect "/home"
end

# remove contact from list
post "/contact/:id/delete" do 
  id = params[:id].to_i
  #binding.pry
  session[:contacts].reject! { |contact| contact.id == id }
  #binding.pry

  redirect "/home"
end


