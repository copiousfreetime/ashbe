require 'ashbe'
require 'forwardable'

module Ashbe
  #
  # A Row is what is returned from a get or scan
  #
  class Row
    include ::Ashbe::StructLike

    ### Hash Delegation ###
    extend Forwardable
    def_delegators :@column_families,
      :empty?, :length, :size,
      :[], :[]=, :has_key?, :fetch, :store, :keys, :values,
      :each, :each_pair, :each_key, :each_value

    alias_method :column_families, :keys

    attr_accessor :rowid

    #
    # Create a Row object from a Hbase Result object.
    #
    # It is assumed that all column family names and qualifiers are Strings.
    # The value is kept as is, and the timestamp is kept as is.
    #
    def initialize( result )
      @rowid= result.getRow
      @rowid.extend( Ashbe::FromBytes )

      @column_families = Hash.new

      result.raw.each do |key_value|

        column_family_name = BytesConversion.to_string( key_value.getFamily )
        column_family      = (@column_families[column_family_name] ||= ColumnFamily.new( column_family_name ))

        qualifier_name     = BytesConversion.to_string( key_value.getQualifier )
        cell               = Cell.new( key_value.getValue, key_value.getTimestamp )

        column_family.store( qualifier_name, cell )
      end
    end
  end
end
