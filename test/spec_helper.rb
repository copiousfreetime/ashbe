require 'ashbe'

puts "Requiring jars..."
SPEC_DIR = File.dirname( __FILE__ )

Ashbe.initialize( File.expand_path( SPEC_DIR, "jars" ) )
