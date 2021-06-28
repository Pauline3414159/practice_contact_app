class Address
  attr_accessor :street_1, :street_2, :city, :state, :zipcode
 
    def all
      "#{street_1} #{city}, #{state} #{zipcode}"
    end

    def to_h
      instance_variables.each_with_object({}) do |var, hsh|
        hsh[var.to_s.gsub('@', '')] = instance_variable_get(var) if instance_variable_get(var)
      end
    end
end