ENV['RACK_ENV'] = "test" #prevents sinatra from starting a web server when testing

require 'minitest/autorun'
require "rack/test"
require_relative '../lib/contact'
require_relative '../lib/address'
require_relative '../app.rb'

class ContactTest < Minitest::Test
  include Rack::Test::Methods # This module gives us methods to work with
  
  def app # These methods expect a method called app to exist and will return an instance of a Rack application when called.
    Sinatra::Application
  end

  def create_contacts(first, last)
    contact
   p  Contact.new(first: first, last: last).to_h
  end
  
  def test_index
    get "/home"
    assert_equal(200, last_response.status)
    assert_equal("text/html;charset=utf-8", last_response["Content-Type"])
  end
  
  
  # validate the response contains the names of the contacts
  def test_creating_contact
    post "/create_contact", params = {first: "Andrew", last: "Roberts", id: "1"}
    
    assert_equal 302, last_response.status
    
    get last_response["Location"]
    last_request.env["rack.session"]
    assert_includes(last_response.body, "Andrew")
    assert_includes(last_response.body, "Roberts")
  end
  
  # "rack.session"=>
  # {"session_id"=>"fe5b02ad9ac2f22627784d3be17352395db8dd046742e6ea54a6a884bf9cf609", "csrf"=>"635a730d874114bfe8099c0164b0a459", "tracking"=>{"HTTP_USER_AGENT"=>"da39a3ee5e6b4b0d3255bfef95601890afd80709", "HTTP_ACCEPT_LANGUAGE"=>"da39a3ee5e6b4b0d3255bfef95601890afd80709"}, "contacts"=>[{"first"=>"Andrew", "last"=>"Roberts", "id"=>4, "address"=>{}}]}

# validate the response contains the contact from the session object
  def test_editing_contact
    get "/home", {},  {"rack.session" => { "contacts" => ["first" => "Jane", "last" => "Eyre", "id" => "5", "address" => {}] }  }
    
    assert_equal(200, last_response.status)
    assert_equal("text/html;charset=utf-8", last_response["Content-Type"])
    assert_includes(last_response.body, "<td>Jane</td>")
    assert_includes(last_response.body, "<td>Eyre</td>")
  end

  def test_adding_only_one_name_causes_error
    assert_raises(ArgumentError) do
      Contact.new(first:'jane', phone:'8575309')
    end
  end

  def test_adding_numbers_to_names_is_cleaned
    aaa = Contact.new(first:'Apples45', last: '33laSt')
    assert_equal('Apples', aaa.first)
    assert_equal('Last', aaa.last)
  end

  def test_ids_are_different
    aaa = Contact.new(first:'Apples45', last: '33laSt')
    bbb = Contact.new(first:'Apples45', last: '33laSt')
    refute aaa.id == bbb.id
  end

  def test_adding_phone_via_hash_arg
    aaa = Contact.new(first:'Apples45', last: '33laSt', **{phone: '55555555'})
    assert_equal('55555555', aaa.phone)
  end

  def test_adding_email_via_method
    aaa = Contact.new(first:'Apples45', last: '33laSt')
    aaa.email=('dake@github.com')
    assert_equal('dake@github.com', aaa.email)
  end

  def test_editing_phone_names_are_cleaned
    aaa = Contact.new(first:'Apples45', last: '33laSt', **{phone: '55555555'})
    aaa.phone=('esee789kmem')
    assert_equal('789', aaa.phone)
  end

  def test_getting_a_hash
    aaa = Contact.new(first:'Apples45', last: '33laSt', **{phone: '55555555'})
    result = aaa.to_h
    result.delete("id") #it's a new id each time because of how the tests are run
    assert_equal({"first"=>"Apples", "last"=>"Last", "phone"=>"55555555"}, result)
  end

end