# Store A person's name, birthday, and contact information. Names are
# automatically cleaned of non-alpha charachters. Phone numbers are
# cleaned of non numeric charachters. Only first and last names are
# mandatory
class Contact
  @@contacts = 0

  CATEGORIIES = %w[work family friends services].freeze

  def initialize(first:, last:, **info)
    @first = first.downcase.gsub(/[^a-z]/, '').capitalize
    @last = last.downcase.gsub(/[^a-z]/, '').capitalize
    if info[:id]
      @id = info[:id]
    else
      @@contacts += 1
      @id = @@contacts.dup
    end
    optionals(**info)
  end

  attr_reader :first, :last, :phone
  attr_accessor :email, :birthday, :address, :id

  def first=(new_name)
    @first = new_name.downcase.gsub(/[^a-z]/, '').capitalize
  end

  def last=(new_name)
    @last = new_name.downcase.gsub(/[^a-z]/, '').capitalize
  end

  def phone=(new_phone)
    @phone = new_phone.gsub(/[^0-9]/, '')
    @phone.insert(3, '-').insert(-5, '-')
    @phone
  end

  def to_h
    instance_variables.each_with_object({}) do |var, hsh|
      hsh[var.to_s.gsub('@', '')] = instance_variable_get(var) if instance_variable_get(var)
    end
  end

  private

  def optionals(**info)
    @email = info[:email]
    @phone = info[:phone].insert(3, '-').insert(-5, '-')
    @birthday = info[:birthday]
    @address = info[:address]
    @category = info[:category] if CATEGORIIES.include?(info[:category.downcase])
  end
end