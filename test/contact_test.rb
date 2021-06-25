require 'minitest/autorun'
require_relative '../lib/contact'

class TestContact < Minitest::Test
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