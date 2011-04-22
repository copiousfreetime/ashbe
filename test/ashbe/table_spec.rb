require 'spec_helper'

describe Ashbe::Table do

  before do
    @config     = ::Ashbe::Configuration.new( spec_config_files )
    @admin      = ::Ashbe::Admin.new( @config )
    @table_name = "test_table"
    @families   = %w[ foo bar baz ].collect { |c| Ashbe::ColumnFamily::Meta.new( c ) }.sort_by{ |f| f.name }
    @admin.create_table( @table_name, @families ) unless @admin.table_exists?( @table_name )
    @table      = ::Ashbe::Table.new( @table_name, @config )
    @data = { 'foo' => { 'one'    => '1', 'two' => '2' },
              'bar' => { 'four'   => '4', 'six' => '6', 'eights' => 888 },
              'baz' => { 'wibble' => 'a' } }
    @row_criteria = @table.put( 12345, @data )

  end

  after do
    if @admin.table_exists?( @table_name ) then
      @admin.drop_table( @table_name )
    end
  end

  it "can connect to a table" do
    t = ::Ashbe::Table.new( @table_name, @config )
    t.is_auto_flush?.must_equal true
  end

  it "can access the table's meta data" do
    @table.name.must_equal @table_name
    @table.meta.column_families.size.must_equal @families.size
  end

  it "can put a row into the table" do
    @row_criteria.rowid.must_equal 12345
    @row_criteria.column_families.size.must_equal 3
  end


  it "can put a row into the table and retrieve it back out" do
    row = @table.get( 12345 )
    row.rowid.to_fixnum.must_equal 12345
    row.column_families.size.must_equal 3
    row.foo.one.last_value.to_string.must_equal '1'
    row.bar.eights.last_value.to_fixnum.must_equal 888
    row.baz.wibble.last_value.to_string.must_equal 'a'
  end

  it "can put a row into the table and retrieve just a column familiy" do
    row = @table.get( 12345, { 'foo' => :all, 'bar' => :all } )
    row.rowid.to_fixnum.must_equal 12345
    row.column_families.size.must_equal 2
    row.foo.one.last_value.to_string.must_equal '1'
    row.bar.eights.last_value.to_fixnum.must_equal 888
    lambda { row.baz }.must_raise NoMethodError
  end

  it "can put a row into the table and retrieve just a column family and qualifier" do
    row = @table.get( 12345, { 'foo' => :all, 'bar' => %w[ six ] } )
    row.rowid.to_fixnum.must_equal 12345
    row.column_families.size.must_equal 2

    row.foo.one.last_value.to_string.must_equal '1'
    row.bar.six.last_value.to_string.must_equal '6'

    lambda { row.bar.eight }.must_raise NoMethodError
    lambda { row.bar.four  }.must_raise NoMethodError
    lambda { row.baz       }.must_raise NoMethodError
  end

  it "can delete a row that exists in the table" do
    @table.delete( 12345 )
    row = @table.get( 12345 )
    row.must_be_nil
  end

  it "can delete just some column families from a row that exists in the table" do
    @table.delete( 12345, { 'baz' => :all, 'bar' => %w[ four six ] })
    row = @table.get( 12345 )
    row.foo.one.last_value.to_string.must_equal '1'
    row.foo.two.last_value.to_string.must_equal '2'
    row.bar.eights.last_value.to_fixnum.must_equal 888

    lambda { row.bar.four }.must_raise NoMethodError
    lambda { row.bar.six  }.must_raise NoMethodError
    lambda { row.baz      }.must_raise NoMethodError
  end

  it "can scan through through a set of rows" do
    10.times { |x|  @table.put(x, @data ) }
    rows = []
    @table.scan( 2..7 ) do |row| # this should also spit a warning out
      rows << row
    end
    rows.size.must_equal 5
    rows.first.rowid.to_fixnum.must_equal 2
  end

  it "can know that a row does not exist in the table" do
    @table.exists?( 54321 ).must_equal false
  end

  it "can know that a row does exist in the table" do
    @table.exists?( 12345 ).must_equal true
  end
end
