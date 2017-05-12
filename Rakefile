require File.expand_path('../config/boboot', __FILE__)
Boboot.require_boot!

require 'rake'
require 'rake/testtask'
require 'rake/task'

Rake::TestTask.new do |t|
  t.libs << %w(test lib)
  t.pattern = 'test/**/*_test.rb'
end

task :default => :test

FileList['rakelib/**/*.rb', 'rakelib/**/*.rake'].to_a.uniq.
  each { |f| import File.join(THOMAS_ROOT_PATH, f) }

desc 'Perform house cleaning in the docker environment'
task :docker_cleanup do
  `docker rmi $(docker images -f "dangling=true" -q)`
  `docker volume rm $(docker volume ls -qf dangling=true)`
  `docker rmi $(docker images | grep "^<none>" | awk "{print $3}")`
end
