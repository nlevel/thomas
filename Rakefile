require File.expand_path('../config/boboot', __FILE__)
Boboot.require_boot!

require 'rake'
require 'rake/testtask'
require 'rake/task'
require 'docker_task'

CONTAINERS = [ 'baseimage', 'baseruby', 'gitti', 'konsol', 'reddys',
               'rubydev23', 'rubydev24', 'squidy', 'rubydev22', 'rubydev19' ]

Rake::TestTask.new do |t|
  t.libs << %w(test lib)
  t.pattern = 'test/**/*_test.rb'
end

task :default => :test

FileList['rakelib/**/*.rb', 'rakelib/**/*.rake'].to_a.uniq.
  each { |f| import File.join(THOMAS_ROOT_PATH, f) }

desc 'Perform house cleaning in the docker environment'
task :docker_cleanup do
  sh 'docker rmi $(docker images -f "dangling=true" -q); true'
  sh 'docker volume rm $(docker volume ls -qf dangling=true); true'
  sh 'docker rmi $(docker images | grep "^<none>" | awk "{print $3}"); true'
end

desc 'Push all latest to Docker Hub'
task :docker_pushall do
  CONTAINERS.each do |c_name|
    sh 'cd %s; rake docker:push' % c_name
  end
end

desc 'Pull all latest from Docker Hub'
task :docker_pullall do
  CONTAINERS.each do |c_name|
    sh 'cd %s; rake docker:pull' % c_name
  end
end

desc 'Build all docker images'
task :docker_buildall do
  CONTAINERS.each do |c_name|
    sh 'cd %s; rake docker:build' % c_name
  end
end
