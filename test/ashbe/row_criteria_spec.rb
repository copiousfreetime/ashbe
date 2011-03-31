require 'spec_helper'

describe Ashbe::RowCriteria do

  before do
    @data = { 'foo' => :all, 
              'bar' => %w[ four six ],
              'baz' => 'wibble' }
    @criteria = ::Ashbe::RowCriteria.new( "12345", @data )
  end

  it "Has a rowid" do
    criteria = Ashbe::RowCriteria.new( 12345 )
    criteria.rowid.must_equal 12345
  end

  it "can convert to a java Put object" do

    put_data = { 'foo' => { 'one'    => '1', 'two' => '2' },
                 'bar' => { 'four'   => '4', 'six' => '6' },
                 'baz' => { 'wibble' => 'a' } }
    criteria = ::Ashbe::RowCriteria.new( "12345", put_data )
    p = criteria.to_put
    p.size.must_equal 5
    p.has( "foo".to_bytes, "one".to_bytes  ).must_equal true
  end

  it "can take a range as the first parameter to have a first and last row" do
    c = Ashbe::RowCriteria.new( "a".."z" )
    c.first_rowid.must_equal "a"
    c.last_rowid.must_equal "z"
  end

  it "when taking a non-range as the first parameteter, last_rowid must be null" do
    c = Ashbe::RowCriteria.new( "foo" )
    c.first_rowid.must_equal "foo"
    c.rowid.must_equal "foo"
    c.last_rowid.must_be_nil
  end

  it "can be created from a nested hash" do
    @criteria.rowid.must_equal "12345"
    lambda { @criteria.foo.one }.must_raise NoMethodError
    @criteria.foo.qualifiers.size.must_equal 0
    @criteria.bar.qualifiers.values.collect { |x| x.name }.sort.must_equal %w[ four six ]
    @criteria.column_families.sort.must_equal @data.keys.sort
  end
end

