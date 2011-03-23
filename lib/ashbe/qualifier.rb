require 'ashbe'
require 'forwardable'

module Ashbe
  #
  # A container holding a sorted list of Cell's and a name.
  #
  class Qualifier
    include Enumerable

    # the name of the qualifier
    attr_reader :name

    # all the cells in this qualifier
    attr_reader :cells

    ### Array Delegation ###
    extend Forwardable
    def_delegators :@cells,
      :empty?, :length, :size, :[], :each, :each_index,
      :index, :insert, :last

    def initialize( name, cells = [] )
      @name = name.to_s
      @cells = Array.new

      [ cells ].flatten.each do |cell|
        @cells << Cell.new( cell )
      end
      @cells.sort!
    end

    def <<( *other )
      insert_sorted( *other )
      return self
    end
    alias push  <<
    alias shift <<

    def insert_sorted( *other )
      other.flatten.each do |o|
        idx = index { |i| i >= o } || length
        insert(idx , o )
      end
    end
  end
end
