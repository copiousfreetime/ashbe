require 'spec_helper'

describe Ashbe::ColumnFamily do
  before do
    @cf = ::Ashbe::ColumnFamily.new( "foo" )
    @qs = [ ::Ashbe::Qualifier.new( 'wibble', 'snorf' ),
            ::Ashbe::Qualifier.new( 'wobble', 'sniff' ), ]
  end

  it "should have a name" do
    @cf.name.must_equal "foo"
  end

  it "can add a new qualifier" do
    q = ::Ashbe::Qualifier.new( 'wibble', "snorf" )
    @cf << q
    @cf['wibble'].last.value.must_equal "snorf"
  end

  it "can add a new qualifier via a shortcut" do
    @cf['wibble'] = "snorf"
    @cf['wibble'].last.value.must_equal "snorf"
  end

  it "can access a qualifier via a method of the same name" do
    @cf['wibble'] = 'snorf'
    @cf.wibble.last.value.must_equal 'snorf'
  end

  it "can create a qualifier via struct like acccess" do
    @cf.wibble = "snorf"
    @cf.wibble.last_value.must_equal "snorf"
  end

  it "raise an exception if accessing an invalid qualifier name via struct like access" do
    lambda { @cf.worble }.must_raise IndexError
  end

  it "can be filled with an array of qualifiers" do
    @cf << @qs
    @cf.size.must_equal 2
  end

  it "can be filled via a hash" do
    @cf << { "wibble" => "snorf", "wobble" => "sniff" }
    @cf.size.must_equal 2
  end

  it "can be chain filled" do
    @cf << { "wibble" => "snorf" } << { "wobble" => "sniff" }
    @cf.size.must_equal 2
  end

  it "raises an exception if it does not know how to deal with the argument to add_qualifier" do
    lambda { @cf.add_qualifier( 42 ) }.must_raise ArgumentError
  end

  it "can iterate over the qualifiers" do
    @cf << @qs
    @cf.size.must_equal 2
    out = []
    @cf.each do |qname, qual|
      out << qual
    end
    out.must_equal @qs
  end

end
