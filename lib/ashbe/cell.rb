module Ashbe
  # 
  # An array of Cell's is what is reference by a particular
  # row/column_family.qualifier
  #
  class Cell
    include Comparable

    attr_accessor :value
    attr_accessor :timestamp

    #
    # Create the cell with the given value and possible timestamp.  If no
    # timestamp is given, then it is nil.  By default timestamps are assigned by
    # the HBase system.
    #
    def initialize( value, timestamp = nil )
      @value     = value
      @timestamp = timestamp
    end

    def <=>( other )
      return 0  if @timestamp == other.timestamp
      return -1 if @timestamp.nil? && (!other.timestamp.nil?)
      return 1  if (!@timestamp.nil?) && other.timestamp.nil?

      return -1 if @timestamp < other.timestamp
      return 1  if @timestamp > other.timestamp
    end
  end
end
