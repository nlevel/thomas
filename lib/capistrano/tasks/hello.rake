desc 'Display hello world'
task :hello do
  on roles(:all) do
    puts 'Hello World for %s' % host
  end
end
