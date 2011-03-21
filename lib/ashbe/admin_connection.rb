require 'ashbe'

module Ashbe
  class AdminConnection < ::Ashbe::Java::HBaseAdmin
    def self.is_hbase_available?( config = Configuration.new )
      begin
        ::Ashbe::Java::HBaseAdmin.checkHBaseAvailable( config )
        return true
      rescue => e
        return false
      end
    end

    def initialize( config = Configuration.new )
      super( config )
    end

    #
    # Check and see if we are connected to the hbase cluster by asking for the
    # cluster status.  
    #
    # TODO: have a ClusterStatus object too.. ?
    #
    def connected?
      begin
        clusterStatus
        return true
      rescue => e
        return false
      end
    end

    alias configuration getConfiguration

    #
    # Return a table connection for the given table
    #
    def table_connection_to( table_name )
      ::Ashbe::TableConnection.new( table_name, self.configuration )
    end

    def create_table( table, families, &block )
      t = Table.new( table, families, &block )
      createTable( t.to_htable )
    end


    #
    # This will drop a table from the system, this means first disabling it and
    # then deleteing ig
    #
    def drop_table( table_name )
      disable_table( table_name )
      delete_table( table_name )
    end
    alias table_exists? tableExists
    alias delete_table  deleteTable
    alias disable_table disableTable

    #
    # Return an array of all the known tables in hbase cluster
    #
    def tables
      listTables.collect { |t| Table.new( t ) }
    end

  end
end
