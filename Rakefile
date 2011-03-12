# vim: syntax=ruby

begin
  require 'rubygems'
  require 'hoe'
rescue LoadError 
  abort <<-_
  Developing ashbe requires the use of rubygems and hoe.

    gem install hoe
  _
end

Hoe.plugin :doofus, :git, :gemspec2

Hoe.spec 'ashbe' do
  developer 'Jeremy Hinegardner', 'jeremy@copiousfreetime.org'

  # Use rdoc for history and readme
  self.history_file = 'HISTORY.rdoc'
  self.readme_file  = 'README.rdoc'

  self.extra_rdoc_files = [ self.readme_file, self.history_file ]

  # test with minitest
  self.extra_dev_deps << [ 'minitest', '~> 2.0.2']
  self.testlib         = :minitest
  self.test_globs      = ["test/**/*_spec.rb"]

  # and we use autotest
  self.extra_dev_deps << [ 'ZenTest', '~> 4.5.0' ]

  # buildr for downloading the jars needed to run the tests
  self.extra_dev_deps << [ 'buildr', '~> 1.4.4' ]
end

