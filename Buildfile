# vim: ft=rby

#
# For testing purposes, use buildr to download all the jars necessary to run the
# tests. Store them in 'test/jars'
#
repositories.remote << "http://repo1.maven.org/maven2"

ARTIFACTS = [
  # Releases
  artifact( %w[ org.apache.hbase       hbase             jar        0.90.0        ].join(":") ),
  artifact( %w[ com.google.guava       guava             jar        r06           ].join(":") ),
  artifact( %w[ org.apache.zookeeper   zookeeper         jar        3.3.2         ].join(":") ),
  artifact( %w[ org.apache.hadoop      hadoop-core       jar        0.20.2        ].join(":") ),
  artifact( %w[ commons-logging        commons-logging   jar        1.1.1         ].join(":") ),
  artifact( %w[ commons-lang           commons-lang      jar        2.5           ].join(":") ),
  artifact( %w[ commons-codec          commons-codec     jar        1.4           ].join(":") ),
  artifact( %w[ log4j                  log4j             jar        1.2.16        ].join(":") ),

  # Testing only
  artifact( %w[ org.apache.hbase       hbase             jar tests  0.90.0        ].join(":") ),
  artifact( %w[ org.apache.hadoop      hadoop-test       jar        0.20.2        ].join(":") ),
  artifact( %w[ org.mortbay.jetty      jetty             jar        6.1.26        ].join(":") ),
  artifact( %w[ org.mortbay.jetty      jetty-util        jar        6.1.26        ].join(":") ),
  artifact( %w[ org.mortbay.jetty      servlet-api-2.5   jar        6.1.14        ].join(":") ),
  artifact( %w[ commons-cli            commons-cli       jar        1.2           ].join(":") ),

].flatten

define 'ashbe' do
  dirname = File.expand_path( 'test/jars', File.dirname( __FILE__ ) )
  
  directory dirname

  desc "Download all the jars to the '#{dirname}' directory"
  task :download_jars => [ dirname, 'artifacts' ] do
    ARTIFACTS.each do |art|
      dest_file = File.join( dirname, File.basename( art.name ) )
      FileUtils.cp art.name, dest_file, :verbose => true
      FileUtils.chmod( 0644, dest_file )
    end
  end
end

task :default => 'ashbe:download_jars'

