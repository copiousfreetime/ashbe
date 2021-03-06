require 'ashbe'

module Ashbe
  class Table
    # 
    # The meta data about a table. Inherits HTableDescriptor in java land
    #
    class Meta < ::Ashbe::Java::HTableDescriptor
      #
      # Create a new Ashbe::Table from a HTableDescriptor
      #
      def self.from_htable( htable )
        families = htable.getFamilies.collect { |f| ColumnFamily::Meta.new( f ) }
        Table::Meta.new( htable.getNameAsString, families )
      end
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
        hasFamily( family_name.to_bytes )
      end

      #
      # returns an array of the ColumnFamily's making up this table
      #
      def families
        getFamilies.collect { |f| ColumnFamily::Meta.new( f ) }
      end

      #
      # retrieve the ColumnFamily for the given name
      #
      def fetch_family( family_name )
        getFamily( family_name.to_bytes )
      end

      def to_htable
        ::Ashbe::Java::HTableDescriptor.new( self )
      end
    end
  end
end
