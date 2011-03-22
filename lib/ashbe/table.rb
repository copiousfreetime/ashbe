require 'ashbe'

module Ashbe
  class Table
    java_implements "org.apache.hadoop.hbase.client.HTableInterface"

    # Name of the table
    attr_reader :table_name

    # The ::Ashbe::Configuration used to connect
    attr_reader :config

    def initialize( table_name, config = Configuration.new )
      @table_name = table_name
      @config     = config
      @htable     = ::Ashbe::Java::HTable.new( @config, @table_name )
    end

    def is_auto_flush?
      @htable.isAutoFlush
    end

    #
    # Put the given data into 
    def put( row_or_key, data = {} )

    end
  end
end
