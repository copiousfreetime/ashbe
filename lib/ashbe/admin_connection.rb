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

  end
end
