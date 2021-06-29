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
  def complete_address(address)
   
    string = ""
    address.each_pair do |key, value|
      value += "," if key == "city" && value.length > 1
      unless value.length < 1
        string << value  + " "
      end
    end

    string
  end

  def add_address(street_1, street_2, city, state, zipcode)
    address = Address.new
    address.street_1 = street_1
    address.street_2 = street_2
    address.city = city
    address.state = state if state
    address.zipcode = zipcode
    address
  end
  
  def load_contacts(id)
    contact = session[:contacts].find { |contact| contact["id"] == id }
  
    session[:error] = "The specified contact was not found."
    return contact if contact
    redirect "/home"
  end
  
  def to_h
    instance_variables.each_with_object({}) do |var, hsh|
      hsh[var.to_s.gsub('@', '')] = instance_variable_get(var) if instance_variable_get(var)
    end
  end

  def update_contact(contact, params)
    contact["first"] = params[:first].capitalize
    contact["last"] = params[:last].capitalize
    contact["address"]["street_1"] = params[:street_1]
    contact["address"]["stree_2"] = params[:street_2]
    contact["address"]["city"] = params[:city]
    contact["address"]["state"] = params[:state] if params[:state]
    contact["address"]["zipcode"] = params[:zipcode]
    contact["email"] = params[:email]
    contact["phone"] = params[:phone]
    contact
  end

  def sort_direction(column_name)
    return "asc" if @contacts.empty?
   order = if @contacts.first[column_name] < @contacts.last[column_name]
    "desc"
   elsif @contacts.first[column_name] > @contacts.last[column_name]
    "asc"
   end
   order
  end
  
  def sortable(column_name)
    direction =  sort_direction(column_name) == "asc" ? "asc" : "desc" 
    "#{column_name}/#{direction}"
  end
end 

get "/" do 
  redirect "/home"
end

# View list of contacts
get "/home" do
  #binding.pry
  @contacts = session[:contacts]
  erb(:index)
end

# Render the new Contact Form
get "/home/create_contact" do 
  erb(:create)
end

# Create new contact
post "/create_contact" do 
  address = add_address(params[:street_1], params[:street_2], params[:city], params[:state], params[:zipcode]).to_h
  session[:contacts] << Contact.new(first: params[:first], last: params[:last], phone: params[:phone], email: params[:email], address: address).to_h
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
  @contact = load_contacts(@id)
  @contact = update_contact(@contact, params)
  redirect "/home"
end

# remove contact from list
post "/contact/:id/delete" do 
  id = params[:id].to_i
  #binding.pry
  session[:contacts].reject! { |contact| contact["id"] == id }
  #binding.pry
  
  redirect "/home"
end

def order_by(key, direction)
  if direction == "asc"
    session[:contacts].sort_by { |hsh| hsh[key] }
  elsif direction == "desc" 
    session[:contacts].sort_by { |hsh| hsh[key] }.reverse
  end
end

#sort by a column
get "/home/:sort/:direction" do 
  key = params[:sort]
  direction= params[:direction]
  session[:contacts] = order_by(key, direction)
  redirect "/home"
end


