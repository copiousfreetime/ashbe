module Ashbe
  module Test
    class Cluster
      def self.config_files
        config_dir = File.expand_path( "../spec/data/config", File.dirname( __FILE__ ))
        Dir.glob( File.join( config_dir, "*.xml" ) )
      end

      attr_reader :config

      def initialize( config_files = Cluster.config_files )
        @config  = ::Ashbe::Configuration.new( config_files )
        @utility = org.apache.hadoop.hbase.HBaseTestingUtility.new( @config )
      end

      def start
        @utility.startMiniCluster
      end

      #
      # I still do not undestand how raising an exception can be the 'normal' flow
      # of work for this
      #
      def running?
        begin
          @utility.isRunningCluster( nil )
          return false
        rescue java.io.IOException => e
          if e.message =~ /Cluster already running/
            return true
          end
          return false
        end
      end

      def stop
        @utility.shutdownMiniCluster
      end
    end
  end
end

