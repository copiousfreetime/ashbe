require 'ashbe'

module Ashbe
  # 
  # A Wrapper for the HBaseConfiguration class. 
  #
  class Configuration < org.apache.hadoop.conf.Configuration
    #
    # Create a new Configuration. A list of additional filenames may be passed in.
    # These are assumed to exist on the filesystem and their contents will be
    # added to the base Configuration.
    #
    def initialize( filenames = [] )
      super( org.apache.hadoop.hbase.HBaseConfiguration.create )
      filenames.each do |path|
        addResource( Ashbe::Java::Path.new( path ) )
      end
    end

    def keys
      collect { |e| e.getKey }
    end

    def []=(key, value)
      set( key, value )
    end

    def []( key )
      get( key )
    end
  end
end
