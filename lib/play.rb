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

def to_h
  instance_variables.each_with_object({}) do |var, hsh|
    hsh[var.to_s.gsub('@', '')] = instance_variable_get(var) if instance_variable_get(var)
  end
end
def test_getting_a_hash
  aaa = Contact.new(first:'Apples45', last: '33laSt', **{phone: '55555555'})
  result = aaa.to_h
  result.delete("id")
  assert_equal({"first"=>"Apples", "last"=>"Last", "phone"=>"55555555"}, result)
end
#contacts = YAML.load_file("contacts.yaml")

p contact.instance_variables