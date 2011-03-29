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


    #
    # Get the given row key and the specified column families and qualifiers
    # from the table.  The 'filters' parameter is a 2 level hash, the top level
    # being the column family names and the second level are qualifiers.
    #
    #   {
    #     'foo_column' => :all,
    #     'bar_column' => [ 'qual1', 'qual2' ]
    #     ...
    #   }
    #
    # At the top level, if there are no column families listed, then all column
    # families and all their data are retrieved.
    #
    #   get( key, filters = :all | nil | :everything )
    #
    # If 'filters' is a hash that has keys in it, then only those column
    # families are retrieved.
    #
    #   get( key, filters = { 'foo' => :all, 'bar' => :all }
    #
    # If the values in the 'filters' hash is an Array of qualifiers, then only
    # those qualifiers for that column famliy are retrieved.
    #
    #   get( key, filters = { 'foo' => %w[ qual1 qual2 ], 'bar' => %w[ age date ]})
    #
    def get( row_key, filters = {} )
      filter = ::Ashbe::Row.new( row_key, filters )
      result = @htable.get( filter.to_get )
      return ::Ashbe::Row.from_result( result )
    end
  end
end
