class Address
  attr_accessor :street_1, :street_2, :city, :state, :zipcode
 
  def all
    if @street_1 && @city && @state &&zipcode
      "#{street_1} #{city}, #{state} #{zipcode}"
    else
      ""
    end
  end
end