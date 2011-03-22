require 'spec_helper'

describe Ashbe::ColumnFamily do
  before do
    @cf = ::Ashbe::ColumnFamily.new( "foo" )
  end

  it "should have a name" do
    @cf.name.must_equal "foo"
  end
end
