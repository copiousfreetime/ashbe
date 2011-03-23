require 'ashbe'

module Ashbe
  class Table

    java_implements "org.apache.hadoop.hbase.client.HTableInterface"

    # The meta data about the table
    attr_reader :meta

    # The ::Ashbe::Configuration used to connect
    attr_reader :config

    def initialize( table_name, config = Configuration.new )
      @config     = config
      @htable     = ::Ashbe::Java::HTable.new( @config, table_name )
      @meta       = Table::Meta.from_htable( @htable.getTableDescriptor )
    end

    def name
      @meta.name
    end

    def is_auto_flush?
      @htable.isAutoFlush
    end

    #
    # TODO: figure out how to extrac all the methods from HTableInterface and
    # delegate them to @htable
    #

    #
    # Put the given row key and row data into the table.  The row_data
    # is a 2 level hash, top level being column family names, the second level
    # are qualifiers and the values there are strings, i.e.:
    #
    #   {
    #     'foo_column' => { 'qual1' => 'val1', ... },
    #     'bar_column' => { 'quala' => 'vala', ... },
    #     ....
    #   }
    #
    # This will return the Asbhe::Row object of the data that was inserted
    #
    def put( row_key, row_data = {} )
      row = ::Ashbe::Row.new( row_key, row_data )
      @htable.put( row.to_put )
      return row
    end
  end
end
