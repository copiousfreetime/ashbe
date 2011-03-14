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
  end
end
