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
    # This will return the Asbhe::RowCriteria object of the data that was inserted
    #
    def put( rowid, row_data = {} )
      criteria = ::Ashbe::RowCriteria.new( rowid, row_data )
      @htable.put( criteria.to_put )
      return criteria
    end


    #
    # Get the given row key and the specified column families and qualifiers
    # from the table.  The 'criteria' parameter is a 2 level hash, the top level
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
    #   get( key, criteria = :all | nil  )
    #
    # If 'criteria' is a hash that has keys in it, then only those column
    # families are retrieved.
    #
    #   get( key, criteria = { 'foo' => :all, 'bar' => :all }
    #
    # If the values in the 'criteria' hash is an Array of qualifiers, then only
    # those qualifiers for that column famliy are retrieved.
    #
    #   get( key, criteria = { 'foo' => %w[ qual1 qual2 ], 'bar' => %w[ age date ]})
    #
    def get( rowid , data = {} )
      criteria = ::Ashbe::RowCriteria.new( rowid, data )
      result = @htable.get( criteria.to_get )
      return nil if result.isEmpty
      return ::Ashbe::Row.new( result )
    end

    #
    # Remove the whole row from the table, or just remove some of the data in a
    # row.
    #
    # The rowid is required, and if 'data' is used, then only the data
    # referenced there is removed.  'data' here works the same as with a #get
    # request.
    #
    def delete( rowid, data = {} )
      criteria = ::Ashbe::RowCriteria.new( rowid, data )
      return @htable.delete( criteria.to_delete )
    end

    #
    # Do a Scan operation on the table.  Optionally give the start and end
    # location, with an additional 'data' parameter in the same manner as #get
    # and #delete.
    #
    # If using both a start and end, then specify it as a Range that is
    # non-inclusive of the end parameter i.e (start...end).
    #
    # Hbase scanning will not return the 'end' row.
    #
    # scan yields each result Row
    #
    def scan( exclusive_range, data = {}, &block )
      warn "Hbase will not return the row with id '#{exclusive_range.end}'.  You probably want (#{exclusive_range.begin}...#{exclusive_range.end})" unless exclusive_range.exclude_end?
      criteria = ::Ashbe::RowCriteria.new( exclusive_range, data )
      results_scanner = @htable.getScanner( criteria.to_scan )
      results_scanner.each do |result|
        yield ::Ashbe::Row.new( result )
      end
      results_scanner.close
    end
  end
end
