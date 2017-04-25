require 'rake'

module Thomas
  class DockerTask < Rake::TaskLib
    DEFAULT_OPTIONS = {
      :namespace => :docker
    }

    DOCKER_CMD = 'docker'
    GCLOUD_DOCKER_CMD = 'gcloud docker'

    attr_reader :options

    def initialize(options = { })
      @options = DEFAULT_OPTIONS.merge(options)
      yield(self) if block_given?
    end

    def task_namespace
      @options[:namespace]
    end
    alias :ns :task_namespace

    def container_name
      @options[:container_name]
    end

    def image_name
      @options[:image_name]
    end

    def define!
      namespace ns do
        desc 'Perform whole cycle of destroy (if any), build, and run'
        task :reset do
          invoke_task('destroy')
          invoke_task('build')
          invoke_task('run')
        end

        desc 'Rebuild the docker image'
        task :rebuild do
          invoke_task('destroy')
          invoke_task('build')
        end

        desc 'Build a new docker image based on the Dockerfile'
        task :build do
          docker_do 'build -t %s .' % image_name
        end

        desc 'Show help, and how to use this docker tool'
        task :help do
          puts help_text
        end

        desc 'Run the latest docker image'
        task :run do
          run_opts = [ ]

          if ENV['INTERACTIVE'] == '1'
            run_opts << '--rm -t -i'
          else
            run_opts = @options[:run].call(self, run_opts)

            run_opts << '-d'
            run_opts << '--name=%s' % container_name
          end

          run_opts << '%s:%s' % [ @options[:image_name], @options.fetch(:image_tag, 'latest') ]

          if ENV['INTERACTIVE'] == '1'
            docker_do 'run %s %s' % [ run_opts.join(' '), '/bin/bash -l' ], :ignore_fail => true
          else
            docker_do 'run %s' % run_opts.join(' ')
          end
        end

        desc 'Run docker in interactive mode (with bash shell)'
        task :runi do
          ENV['INTERACTIVE'] = '1'
          invoke_task('run')
        end

        task :bash do
          if @options.include?(:bash)
            exec_cmd = @options[:bash]
          else
            exec_cmd = 'bash -l'
          end

          docker_do('exec -it %s %s' % [ container_name, exec_cmd ], :ignore_fail => true)
        end

        desc 'Run docker container'
        task :start do
          docker_do 'start %s' % container_name
        end

        desc 'Stop docker container'
        task :stop do
          docker_do 'stop %s; true' % container_name
        end

        desc 'Restart docker container'
        task :restart do
          invoke_task('stop')
          invoke_task('start')
        end

        desc 'Delete container, and create a new one'
        task :reload do
          docker_do 'kill %s; true' % container_name
          docker_do 'rm %s; true' % container_name

          invoke_task('run')
        end

        desc 'Push latest built image to repo'
        task :push do
          if @options[:push_repo]
            should_create_tag = false

            if !ENV['PUSH_MIRROR'].nil? && !ENV['PUSH_MIRROR'].empty?
              mk = ENV['PUSH_MIRROR']
              pm = @options[:push_mirrors]

              if !pm.nil? && !pm.empty?
                push_repo = pm[mk.to_sym]
              else
                push_repo = nil
              end

              if push_repo.nil? || push_repo.empty?
                fail "Mirror %s not found" % mk
              end
            else
              push_repo = repo_with_registry(@options[:push_repo], @options[:registry])
            end

            docker_do 'tag %s %s' % [ @options[:image_name], push_repo ]
            docker_do 'push %s' % push_repo
          else
            puts 'Please specify a push_repo for this docker context'
          end
        end

        desc 'Pull from registry based on push_repo options'
        task :pull do
          if @options[:push_repo]
            pull_repo = repo_with_registry(@options[:push_repo], @options[:registry])

            docker_do 'pull %s' % pull_repo
            docker_do 'tag %s %s' % [ pull_repo, @options[:image_name] ]
          else
            puts 'Please specify a push_repo for this docker context'
          end
        end

        desc 'Re-tag a local copy from latest remote (will not pull)'
        task :retag do
          if @options[:push_repo]
            pull_repo = repo_with_registry(@options[:push_repo], @options[:registry])
            docker_do 'tag %s %s' % [ pull_repo, @options[:image_name] ]
          else
            puts 'Please specify a push_repo for this docker context'
          end
        end

        desc 'Remove built container'
        task :destroy do
          docker_do 'kill %s' % container_name, :ignore_fail => true
          docker_do 'rm %s' % container_name, :ignore_fail => true
          docker_do 'rmi %s' % container_name, :ignore_fail => true
        end
      end
    end

    def repo_with_registry(repo_name, registry = nil)
      if registry.nil?
        repo_name
      else
        '%s/%s' % [ registry, repo_name ]
      end
    end

    def docker_cmd(registry = nil)
      if registry.nil?
        DOCKER_CMD
      elsif registry =~ /\.grc\.io/
        GCLOUD_DOCKER_CMD
      else
        DOCKER_CMD
      end
    end

    def docker_do(cmd, opts = { })
      if opts[:ignore_fail]
        cmd += '; true'
      end

      sh '%s %s' % [ docker_cmd, cmd ]
    end

    def invoke_task(tname)
      Rake::Task['%s:%s' % [ ns, tname ]].invoke
    end

    def help_text
      <<-HELP
This is a set of Rake tasks that you can include in your own Rakefile, to aid in managing docker images and containers.
HELP
    end
  end
end
