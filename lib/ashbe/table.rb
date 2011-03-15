require 'ashbe'

module Ashbe
  # 
  # The meta data about a table. Inherits HTableDescriptor in java land
  #
  class Table < ::Ashbe::Java::HTableDescriptor
    include ::Ashbe::Bytes
    #
    # Create a new Table, with the given name and column families.  If a block
    # is given, yield self 
    #
    #   Table.new( "example" ) do |table|
    #     table.add_family( column_family )
    #     ...
    #   end
    #
    def initialize( table_name, families = [], &block )
      super( table_name )
      [ families ].flatten.each do |fam|
        add_family( fam )
      end
      yield self if block_given?
    end

    alias add_family  addFamily
    alias name        getNameAsString

    #
    # Does this table have a column family with the given name
    #
    def has_family?( family_name )
      hasFamily( to_bytes( family_name ) )
    end

    #
    # returns an array of the ColumnFamily's making up this table
    #
    def families
      getFamilies.collect { |f| ColumnFamily.new( f ) }
    end

    #
    # retrieve the ColumnFamily for the given name
    #
    def fetch_family( family_name )
      getFamily( to_bytes( family_name ) )
    end

  end
end
