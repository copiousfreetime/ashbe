require 'spec_helper'

describe Ashbe::Table do

  before do
    @config     = ::Ashbe::Configuration.new( spec_config_files )
    @admin      = ::Ashbe::Admin.new( @config )
    @table_name = "test_table"
    @families   = %w[ foo bar baz ].collect { |c| Ashbe::ColumnFamily::Meta.new( c ) }.sort_by{ |f| f.name }
    @admin.create_table( @table_name, @families )
    @conn       = ::Ashbe::Table.new( @table_name, @config )
  end

  after do
    if @admin.table_exists?( @table_name ) then
      @admin.drop_table( @table_name )
    end
  end

  it "can connect to a table" do
    tc = ::Ashbe::Table.new( @table_name, @config )
    tc.is_auto_flush?.must_equal true
  end

  it "can put a row into the table" do
    row = @conn.put( 12345, { 'foo' => { '1' => 'one',  '2' => 'two' },
                              'bar' => { '4' => 'four', '6' => 'six' },
                              'baz' => { '42' => 'a' } } )
    # TODO:
    #row.key.must_equal 12345
    #row.column_families.size.must_equal 3
  end
end
