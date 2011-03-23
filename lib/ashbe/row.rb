require 'ashbe'
require 'forwardable'

module Ashbe
  class Row
    include ::Ashbe::StructLike

    # the unique key of this row
    attr_reader :key

    ### Hash Delegation ###
    extend Forwardable
    def_delegators :@column_families,
      :empty?, :length, :size,
      :[], :[]=, :has_key?, :fetch, :store, :keys, :values,
      :each, :each_pair, :each_key, :each_value

    alias_method :column_families, :keys

    def initialize( key, data = {} )
      @key             = key
      @column_families = to_column_families_hash( data )
    end

    def to_put
      p = ::Ashbe::Java::Put.new(  key.to_bytes )
      @column_families.each do |column_family_name, column_family|
        column_family.each_value do |qualifier|
          p.add( column_family_name.to_bytes,
                 qualifier.name.to_bytes,
                 qualifier.last_value.to_bytes )
        end
      end

      return p
    end

    ###########################################################################
    private
    ###########################################################################

    def to_column_families_hash( data )
      cf_data = Hash.new
      data.each do |column_family_name, qualifier_hash|
        cf = ::Ashbe::ColumnFamily.new( column_family_name )
        qualifier_hash.each do |qualifier, value|
          cf << ::Ashbe::Qualifier.new( qualifier, value )
        end

        cf_data[column_family_name.to_s] = cf
      end

      return cf_data
    end

  end
end
