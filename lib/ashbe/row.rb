require 'ashbe'
require 'forwardable'

module Ashbe
  class Row
    include ::Ashbe::StructLike

    ### Hash Delegation ###
    extend Forwardable
    def_delegators :@column_families,
      :empty?, :length, :size,
      :[], :[]=, :has_key?, :fetch, :store, :keys, :values,
      :each, :each_pair, :each_key, :each_value

    alias_method :column_families, :keys

    #
    # Create a Row object from a Hbase Result object.
    #
    # It is assumed that all column family names and qualifiers are Strings.
    # The value is kept as is, and the timestamp is kept as is.
    #
    def self.from_result( result )
      row_id = result.getRow
      if row_id.is_bytes? then
        @key.extend( Ashbe::FromBytes )
      end

      row = Row.new( result.getRow )
      result.raw.each do |key_value|

        column_family_name = BytesConversion.to_string( key_value.getFamily )
        column_family      = (row[column_family_name] ||= ColumnFamily.new( column_family_name ))

        qualifier_name     = BytesConversion.to_string( key_value.getQualifier )
        cell               = Cell.new( key_value.getValue, key_value.getTimestamp )

        column_family.store( qualifier_name, cell )
      end
      return row
    end

    #
    # The key is always internally a Java object, so if it is a Ruby object on
    # the outset, the we do a #to_bytes on it to convert it to a Java byte array
    # which is what it will be in any case when it goes to hbase.
    #
    def initialize( key, data = {} )
      @key             = key.to_bytes.extend( FromBytes )
      @key_class       = key.class
      @column_families = to_column_families_hash( data )
    end

    def key
      return @key.to_fixnum if @key_class == Fixnum
      return @key.to_string if @key_class == String
      return @key
    end

    def to_put
      p = ::Ashbe::Java::Put.new( @key )
      @column_families.each do |column_family_name, column_family|
        column_family.each_value do |qualifier|
          p.add( column_family_name.to_bytes,
                 qualifier.name.to_bytes,
                 qualifier.last_value.to_bytes )
        end
      end

      return p
    end

    #
    # Convert the Row to and Hbase Get object.  This means converting the
    # 'column_families' attribute into a filter-like object for the Get.
    #
    # If column_families is empty, then we do no filter.
    #
    # If column_families has data, and those column families have qualifiers
    # then we filter down to the qualifier level.
    #
    # If column_families has data, but those column families have no qualifiers
    # then we filter at the column familiy level
    #
    def to_get
      g = ::Ashbe::Java::Get.new( @key )

      @column_families.each do |column_family_name, column_family|
        all_qualifiers = true
        column_family.each_value do |qualifier|
          all_qualifiers = false
          g.addColumn( column_family_name.to_bytes, qualifier.name.to_bytes )
        end
        g.addColumn( column_family_name.to_bytes ) if all_qualifiers
      end

      return g
    end

    ###########################################################################
    private
    ###########################################################################

    def to_column_families_hash( data )
      cf_data = Hash.new
      data.each do |column_family_name, qualifier_hash|
        cf = ::Ashbe::ColumnFamily.new( column_family_name )
        unless qualifier_hash == :all then
          qualifier_hash.each do |*p|
            p.flatten!
            cf << ::Ashbe::Qualifier.new( p.shift, p.shift )
          end
        end
        cf_data[column_family_name.to_s] = cf
      end

      return cf_data
    end

  end
end
