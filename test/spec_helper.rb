require 'ashbe'

puts "Requiring jars..."
SPEC_DIR = File.dirname( __FILE__ )

Ashbe.initialize( File.expand_path( SPEC_DIR, "jars" ) )

def spec_config_files
  Dir.glob( File.join( SPEC_DIR, "data/config", "*.xml" ) )
end
