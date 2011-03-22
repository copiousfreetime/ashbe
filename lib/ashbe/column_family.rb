module Ashbe
  # 
  # A container holding all the qualifiers in a column family for a particular
  # Row
  #
  class ColumnFamily 

    # The name of this column family
    attr_reader :name

    # all the qualifiers that are held in this column family
    attr_reader :qualifiers

    def initialize( name )
      @name       = name
      @qualifiers = {}
    end

  end
end
