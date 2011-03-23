require 'forwardable'

module Ashbe
  # 
  # A container holding all the qualifiers in a column family for a particular
  # Row
  #
  class ColumnFamily 
    include Enumerable

    # The name of this column family
    attr_reader :name

    # all the qualifiers that are held in this column family
    attr_reader :qualifiers

    ### Hash Delegation ###
    extend Forwardable
    def_delegators :@qualifiers,
      :empty?, :length, :size,
      :[], :[]=, :has_key?, :fetch, :store, :keys, :values,
      :each, :each_pair, :each_key, :each_value

    def initialize( name )
      @name       = name
      @qualifiers = {}
    end
    alias_method :has_qualifier?, :has_key?

    #
    # Add a qualifier to the column family
    #
    def add_qualifier( qual )
      @qualifiers[qual.name] = qual
    end
    alias << add_qualifier

    #
    # shortcut method to adding a qualifier and its value
    # to the column family directly without having to create
    # a Qualifier instance
    #
    def store(qualifier_name, value )
      qual = Qualifier.new( qualifier_name, value )
      add_qualifier( qual )
    end
    alias []= store
  end
end
