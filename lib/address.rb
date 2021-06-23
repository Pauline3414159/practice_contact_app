class Address
  attr_accessor :street_1, :street_2, :city, :state, :zipcode
 
  def all
    "#{street_1} #{city}, #{state} #{zipcode}"
  end
end