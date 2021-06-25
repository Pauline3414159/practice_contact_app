require_relative "contact.rb"


class Address
  attr_accessor :street_1, :street_2, :city, :state, :zip_code
  def all
   "#{street_1} #{city}"
  end
end

def add_address(street_1, street_2, city, state, zip_code)
  address = Address.new
  address.street_1 = street_1
  address.street_2 = street_2
  address.city = city
  address.state = state
  address.zip_code = zip_code
  address
end

address = add_address("123 Main St", "", "Somewhere", "AL", "123456")
contact = Contact.new(first: "jane", last: "doe", address: address)

contact.first = "Jim"
p contact.first