require 'ashbe'
require 'forwardable'

module Ashbe
  #
  # Get, Put, Delete and Scan operations all use a similar set of input critera
  # to determine what column families and to operate upon.  The RowCriteria
  # class encapsulates this into one location.
  #
  class RowCriteria
    include ::Ashbe::StructLike

    ### Hash Delegation ###
    extend Forwardable
    def_delegators :@column_families,
      :empty?, :length, :size,
      :[], :[]=, :has_key?, :fetch, :store, :keys, :values,
      :each, :each_pair, :each_key, :each_value

    alias_method :column_families, :keys

    attr_reader :rowid

    def initialize( rowid, data = {} )
      @rowid           = rowid
      @column_families = to_column_families_hash( data )
    end


    #
    # Convert the RowCriteria to an HBase Put object
    #
    def to_put
      p = ::Ashbe::Java::Put.new( @rowid.to_bytes )
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
      g = ::Ashbe::Java::Get.new( @rowid.to_bytes )

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
      data.each do |column_family_name, qualifier|
        cf = ::Ashbe::ColumnFamily.new( column_family_name )
        case qualifier
        when :all
          # do nothing
        when Hash
          qualifier.each do |name, value|
            cf << Qualifier.new( name, value )
          end
        when Array, String
          [ qualifier].flatten.each do |name|
            cf << name
          end
        else
          raise Ashbe::Error, "I don't know how to process #{column_family_name} => #{qualifier}"
        end
        cf_data[column_family_name.to_s] = cf
      end

      return cf_data
    end

  end
end

