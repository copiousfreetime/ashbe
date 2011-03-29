require 'spec_helper'

describe Ashbe::Cell do
  it "defaults to a nil timestamp" do
    cell = Ashbe::Cell.new( 42 )
    cell.timestamp.must_be_nil
  end

  it "two cells are the same if their timestamps are the same" do
    c1 = Ashbe::Cell.new( 42 )
    c2 = Ashbe::Cell.new( 21 )
    c1.must_equal c2

    c1.timestamp = Time.now
    c2.timestamp = c1.timestamp.dup
    c1.must_equal c2
  end

  it "A cell with a nil timestamp is less than a cell with a value for the timestamp" do
    c1 = Ashbe::Cell.new( 42 )
    c2 = Ashbe::Cell.new( 21, Time.now )
    c1.must_be :<, c2
    c2.must_be :>, c1
  end

  it "A cell with a higher valued timestamp (more recent) sorts higher than a cell with a lower timestamp" do
    c1 = Ashbe::Cell.new( 42, Time.now.to_i )
    c2 = Ashbe::Cell.new( 21, Time.now.to_i + 42 )

    c2.must_be :>, c1
    c1.must_be :<, c2

  end

  it "is sortable" do
    list = []
    now = Time.now
    13.times do |x|
      list << Ashbe::Cell.new( x, now + x )
    end

    list.sort_by{ rand }.sort.must_equal list
    
  end

  it "does nothing if a Cell is created form a Cell" do
    c1 = Ashbe::Cell.new( 42.to_bytes )
    c2 = Ashbe::Cell.new( c1 )
    c2.value.must_equal c1.value
    c2.timestamp.must_equal c1.timestamp
    c2.object_id.must_equal c1.object_id
  end

end
