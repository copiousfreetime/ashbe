require 'ashbe'
module Ashbe
  #
  # A convenience wrapper around the Compression.Algorithm enum to facility
  # compression algorithm lookup
  #
  module Compression
    def algorithms
      ::Ashbe::Java::Compression::Algorithm.values
    end

    def algorithm_for( name )
      ::Ashbe::Java::Compression::Algorithm.valueOf( name.to_s.upcase )
    end
    extend self

    #
    # loop over all the known compression algorithm enums
    # and create constants for them
    #
    algorithms.each do |alg|
      if not const_defined?( alg.name ) then
        const_set( alg.name, alg )
      end
    end
  end
end
