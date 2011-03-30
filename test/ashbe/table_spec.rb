require 'spec_helper'

describe Ashbe::Table do

  before do
    @config     = ::Ashbe::Configuration.new( spec_config_files )
    @admin      = ::Ashbe::Admin.new( @config )
    @table_name = "test_table"
    @families   = %w[ foo bar baz ].collect { |c| Ashbe::ColumnFamily::Meta.new( c ) }.sort_by{ |f| f.name }
    @admin.create_table( @table_name, @families )
    @table      = ::Ashbe::Table.new( @table_name, @config )
    @data = { 'foo' => { 'one'    => '1', 'two' => '2' },
              'bar' => { 'four'   => '4', 'six' => '6', 'eights' => 888 },
              'baz' => { 'wibble' => 'a' } }

  end

  after do
    if @admin.table_exists?( @table_name ) then
      @admin.drop_table( @table_name )
    end
  end

  # it "can connect to a table" do
    # t = ::Ashbe::Table.new( @table_name, @config )
    # t.is_auto_flush?.must_equal true
  # end

  # it "can access the table's meta data" do
    # @table.name.must_equal @table_name
    # @table.meta.column_families.size.must_equal @families.size
  # end

  it "can put a row into the table" do
    row = @table.put( 12345, @data )
    row.rowid.must_equal 12345
    row.column_families.size.must_equal 3
  end

  it "can put a row into the table and retrieve it back out" do
    @table.put( 12345, @data )
    row = @table.get( 12345 )
    row.rowid.to_fixnum.must_equal 12345
    row.column_families.size.must_equal 3
    row.foo.one.last_value.to_string.must_equal '1'
    row.bar.eights.last_value.to_fixnum.must_equal 888
    row.baz.wibble.last_value.to_string.must_equal 'a'
  end

  it "can put a row into the table and retrieve just a column familiy" do
    @table.put( 12345, @data )
    row = @table.get( 12345, { 'foo' => :all, 'bar' => :all } )
    row.rowid.to_fixnum.must_equal 12345
    row.column_families.size.must_equal 2
    row.foo.one.last_value.to_string.must_equal '1'
    row.bar.eights.last_value.to_fixnum.must_equal 888
    lambda { row.baz }.must_raise NoMethodError
  end

  it "can put a row into the table and retrieve just a column family and qualifier" do
    @table.put( 12345, @data )
    row = @table.get( 12345, { 'foo' => :all, 'bar' => %w[ six ] } )
    row.rowid.to_fixnum.must_equal 12345
    row.column_families.size.must_equal 2

    row.foo.one.last_value.to_string.must_equal '1'
    row.bar.six.last_value.to_string.must_equal '6'

    lambda { row.bar.eight }.must_raise NoMethodError
    lambda { row.bar.four  }.must_raise NoMethodError
    lambda { row.baz       }.must_raise NoMethodError
  end

end
