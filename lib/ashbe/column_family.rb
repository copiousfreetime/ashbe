require 'ashbe'

module Ashbe
  # 
  # A wrapper around the HColumnDescriptor
  #
  class ColumnFamily < ::Ashbe::Java::HColumnDescriptor
    #
    # Create a new ColumnFamily, pass in the name of the family and the
    # available options:
    #
    #   :max_version => number versions to keep (default: 3)
    #   :compression => the compresstion to use (default: none)
    #                   valid compression options are :gz, :lzo, :none
    #
    def initialize( family_name, options = {} )
      super( family_name )
      self.max_versions = options[:max_version] || DEFAULT_VERSIONS
      self.compression  = options[:compression] || :none
    end

    alias name          getNameAsString
    alias max_versions= setMaxVersions


    #
    # We want to set the compression for column, which involves doing
    # an algorithm lookup
    #
    def compression=( type )
      setCompressionType( Compression.algorithm_for( type ) )
    end

    #
    # Is this column family compressed?
    #
    def compressed?
      getCompression != Compression::NONE
    end

  end
end
