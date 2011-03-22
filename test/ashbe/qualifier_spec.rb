require 'spec_helper'

describe Ashbe::Qualifier do
  before do
    @q = Ashbe::Qualifier.new( "foo" )
    @cells = [
      Ashbe::Cell.new( 42, Time.now + 100),
      Ashbe::Cell.new( 42, Time.now ),
      Ashbe::Cell.new( 42, Time.now + 50 ), 
    ]
  end

  it "has a name" do
    @q.name.must_equal "foo"
  end

  it "can return the latest cell" do
    @q << @cells
    @q.size.must_equal @cells.size
    @q.last.must_equal @cells[0]
    @q.first.must_equal @cells[1]
  end

  it "keeps the cells sorted" do
    @q << @cells[0]
    @q.push @cells[1]
    @q.shift @cells[2]
    @q.size.must_equal @cells.size
  end
end
