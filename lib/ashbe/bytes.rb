require 'ashbe'

module Ashbe
  class BytesConversion
    #
    # to_bytes( anything ) -> Java::byte[]
    #
    def self.to_bytes( anything )
      ::Ashbe::Java::Bytes.toBytes( anything )
    end

    #
    # is_bytes?( anything ) -> false | true
    #
    def self.is_bytes?( anything )
      anything.instance_of?( ::Java::byte[] )
    end

    #
    # to_string( Java::bytes[] ) -> String
    #
    def self.to_string( bytes )
      ::Ashbe::Java::Bytes.toString( bytes )
    end

    #
    # to_fixnum( Java::bytes[] ) -> Fixnum
    #
    # Ruby fixnums, are backed by java Longs
    #
    def self.to_fixnum( bytes )
      ::Ashbe::Java::Bytes.toLong( bytes )
    end

    #
    # to_float( Java::bytes[] ) -> Float
    #
    # We mean a ruby Float here, not a 4 byte IEEE float
    # In jruby, ruby Float objects are backed by java Doubles
    #
    def self.to_float( bytes )
      ::Ashbe::Java::Bytes.toDouble( bytes )
    end
  end

  #
  # Include or extend on classes to convert thme to Java::byte[]
  #
  module ToBytes
    def to_bytes
      Ashbe::BytesConversion.to_bytes( self )
    end

    def is_bytes?
      Ashbe::BytesConversion.is_bytes?( self )
    end
  end

  #
  # Include or extend this on classes that represent Java::byte[] so they my be
  # converted easily to Strings, Fixnums or Floats
  #
  module FromBytes
    def to_string
      ::Ashbe::BytesConversion.to_string( self )
    end

    def to_fixnum
      ::Ashbe::BytesConversion.to_fixnum( self )
    end

    def to_float
      ::Ashbe::BytesConversion.to_float( self )
    end
  end
end
