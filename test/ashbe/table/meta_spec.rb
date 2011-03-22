require 'spec_helper'

describe Ashbe::Table::Meta do
  before do
    @table_name = "test_table"
    @families   = %w[ foo bar baz ].collect { |c| Ashbe::ColumnFamily::Meta.new( c ) }.sort_by{ |f| f.name }
  end
  it "can create a new table" do
    t = Ashbe::Table::Meta.new( "test_table" )
    t.name.must_equal "test_table"
  end

  it "can add a single family during initialization" do
    t = Ashbe::Table::Meta.new( "test_table",  Ashbe::ColumnFamily::Meta.new( "foo" ) )
    t.families.size.must_equal 1
    t.has_family?( "foo" ).must_equal true
  end

  it "can add a list of famlies during initialization" do
    t = Ashbe::Table::Meta.new( "test_table", @families )
    t.families.size.must_equal 3
    t.has_family?( "bar" ).must_equal true
  end

  it "can add families via a block" do
    t = Ashbe::Table::Meta.new( @table_name ) do |table|
      @families.each do |f|
        table.add_family( f )
      end
    end

    t.families.size.must_equal 3
    t.has_family?( "baz" ).must_equal true

  end

  it "returns all the families" do
    t = Ashbe::Table::Meta.new( "test_table", @families )
    t.families.sort_by { |f| f.name }.must_equal @families
  end
end
