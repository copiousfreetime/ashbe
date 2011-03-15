require 'spec_helper'

describe Ashbe::AdminConnection do
  before do
    @config     = ::Ashbe::Configuration.new( spec_config_files )
    @admin      = ::Ashbe::AdminConnection.new( @config )
    @table_name = "test_admin_connection"
    @families   = %w[ foo bar baz ].collect { |c| Ashbe::ColumnFamily.new( c ) }.sort_by{ |f| f.name }
  end

  it "can test if a server is available" do
    ::Ashbe::AdminConnection.is_hbase_available?( @config ).must_equal true
  end

  it "can connect to a server" do
    conn = ::Ashbe::AdminConnection.new( @config )
    conn.connected?.must_equal true
  end

  it "can create a table" do
    @admin.create_table( @table_name, @families )
  end
end
