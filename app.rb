require "pry"
require "pry-byebug"
require "sinatra"
require "sinatra/reloader"

configure do
  enable :sessions  #Enable sessions in the application so we can persist data between requests. 
  set :session_secret, 'secret'
end
before do 
  session[:contacts] ||= []
end

get "/" do 
  @contacts = session[:contacts] = [
    {
      first_name: "John",
      last_name: "Doe",
      address: "123 Main St.",
      phone: "(123)456-7890",
      email: "johndoe@email.com"
    },
    {
      first_name: "Jane",
      last_name: "Doe",
      address: "123 Main St.",
      phone: "(123)456-4567",
      email: "janedoe@email.com"

    }
  ]
  p @contacts
  erb(:index)
end