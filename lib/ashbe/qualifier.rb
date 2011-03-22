module Ashbe
  # 
  # A container holding a sorted list of Cell's and a name.
  #
  class Qualifier < ::Array

    attr_accessor :name

    def initialize( name, cells = [] )
      @name = name
      super( cells.sort )
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
