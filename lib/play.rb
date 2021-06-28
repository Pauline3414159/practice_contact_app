require_relative "contact.rb"


class Address
  attr_accessor :street_1, :street_2, :city, :state, :zip_code
  def all
   "#{street_1} #{city}"
  end

  def to_h
    instance_variables.each_with_object({}) do |var, hsh|
      hsh[var.to_s.gsub('@', '')] = instance_variable_get(var) if instance_variable_get(var)
    end
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
 address = address.to_h
contact = Contact.new(first: "jane", last: "doe", address: address)
def complete_address(address)
  string = ""
  address.each_pair do |key, value|
   
    value += "," if key == "city"
  
    unless value.length < 1
      string << value  + " "
    end
  end
 string
end
complete_address(address)


contacts = [
  {"first"=>"Aaa","last"=>"Bbb"},
  {"first"=>"Bbb","last"=>"Aaa"}
  ]

  def order_by(contacts, key, direction)
    if direction == "asc"
      contacts.sort_by! { |hsh| hsh[key] } 
    elsif direction == "desc" 
      contacts.sort_by! { |hsh| hsh[key] }.reverse
    end
  end
p contacts
 contacts = order_by(contacts, "first", "desc")
 p contacts