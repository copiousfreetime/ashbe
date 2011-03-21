require 'spec_helper'

describe Ashbe::AdminConnection do
  before do
    @config     = ::Ashbe::Configuration.new( spec_config_files )
    @admin      = ::Ashbe::AdminConnection.new( @config )
    @table_name = "test_admin_connection"
    @families   = %w[ foo bar baz ].collect { |c| Ashbe::ColumnFamily.new( c ) }.sort_by{ |f| f.name }
  end

  after do
    @admin.tables.each do |table|
      @admin.drop_table( table.name )
    end
  end

  it "can test if a server is available" do
    ::Ashbe::AdminConnection.is_hbase_available?( @config ).must_equal true
  end

  it "can connect to a server" do
    conn = ::Ashbe::AdminConnection.new( @config )
    conn.connected?.must_equal true
  end

  it "can create a table" do
    @admin.table_exists?( @table_name ).must_equal false
    @admin.create_table( @table_name, @families )
    @admin.table_exists?( @table_name ).must_equal true

  end

  it "can drop a table" do
    @admin.table_exists?( @table_name ).must_equal false
    @admin.create_table( @table_name, @families )
    @admin.table_exists?( @table_name ).must_equal true
    @admin.drop_table( @table_name )
    @admin.table_exists?( @table_name ).must_equal false
  end

  it "can list the known tables" do
    names = []
    [ 1, 2, 3 ].each do |x|
      name = "#{@table_name}_#{x}"
      names << name
      @admin.create_table( name, @families ) unless @admin.table_exists?( name )
    end

    tables = @admin.tables
    tables.size.must_equal 3
    tables.collect { |t| t.name }.sort.must_equal names.sort
  end

  it "can produce a table connection" do
    @admin.create_table( @table_name, @families )
    conn = @admin.table_connection_to( @table_name )
    conn.table_name.must_equal @table_name
  end

end
