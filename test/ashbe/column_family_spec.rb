require 'spec_helper'

describe Ashbe::ColumnFamily do
  before do
    @cf = ::Ashbe::ColumnFamily.new( "foo" )
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
    @cf.wibble.last.value.must_equal "snorf"
  end

  it "raise an exception if accessing an invalid qualifier name via struct like access" do
    lambda { @cf.worble }.must_raise IndexError
  end

end
