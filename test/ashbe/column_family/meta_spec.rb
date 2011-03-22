require 'spec_helper'

describe Ashbe::ColumnFamily::Meta do
  it "creates a new column_family" do
    c = Ashbe::ColumnFamily::Meta.new( "family_1" )
    c.name.must_equal "family_1"
  end

  it "can be compressed" do
    c = Ashbe::ColumnFamily::Meta.new( "compressed", :compression => :gz )
    c.compressed?.must_equal true
  end
  
  it "can be not compressed" do
    c = Ashbe::ColumnFamily::Meta.new( "not_compressed" )
    c.compressed?.must_equal false
  end
end
