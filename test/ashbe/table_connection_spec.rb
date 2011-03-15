require 'spec_helper'

describe "Ashbe::TableConnection" do

  before do
    @config     = ::Ashbe::Configuration.new( spec_config_files )
    @admin      = ::Ashbe::AdminConnection.new( @config )
    @table_name = "test_table_connection"
    @families   = %w[ foo bar baz ].collect { |c| Ashbe::ColumnFamily.new( c ) }.sort_by{ |f| f.name }
    @admin.create_table( @table_name, @families )
  end

  after do
    if @admin.table_exists?( @table_name ) then
      @admin.drop_table( @table_name )
    end
  end

  it "can connect to a table" do
    tc = ::Ashbe::TableConnection.new( @table_name, @config )
    tc.is_auto_flush?.must_equal true
  end
end
