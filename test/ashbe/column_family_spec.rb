require 'spec_helper'

describe Ashbe::ColumnFamily do
  it "creates a new column_family" do
    c = Ashbe::ColumnFamily.new( "family_1" )
    c.name.must_equal "family_1"
  end

  it "can be compressed" do
    c = Ashbe::ColumnFamily.new( "compressed", :compression => :gz )
    c.compressed?.must_equal true
  end
  
  it "can be not compressed" do
    c = Ashbe::ColumnFamily.new( "not_compressed" )
    c.compressed?.must_equal false
  end
end
