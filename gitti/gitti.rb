module Gitti
  extend FileUtils

  DATA_VOLUME = '/git'
  EXPOSED_PORT = 22

  def self.sync_repos
    git_repos.each do |repo|
      say 'Mirroring %s (%s)' % [ repo, repo_source(repo) ]
      action, dest_path = mirror_or_update(repo)
      say '... (%s) DONE: %s' % [ action, dest_path ]
    end
  end

  def self.mirror_or_update(repo)
    dest_path = repo_dest_path(repo)
    action = nil

    if File.exists?(dest_path)
      action = :update
      update_mirror(dest_path)
    else
      action = :new
      mirror(repo, dest_path)
    end

    [ action, dest_path ]
  end

  def self.repo_dest_path(repo)
    server, repo_name = repo.split(/\:/, 2)

    if repo_name.nil?
      File.join(var_path, repo)
    else
      File.join(var_path, repo_name)
    end
  end

  def self.repo_source(repo)
    server, repo_name = repo.split(/\:/, 2)

    if repo_name.nil?
      '%s:%s' % [ git_server, repo ]
    else
      '%s:%s' % [ server, repo_name ]
    end
  end

  def self.mirror(repo, dest_path)
    sh 'git clone -q --mirror %s %s' % [ repo_source(repo), dest_path ]
  end

  def self.update_mirror(dest_path)
    sh 'cd %s && git fetch -q -p origin' % dest_path
  end

  def self.setup_ssh_keys
    use_private_key = run_opts['private_key']

    ssh_path = Gitti.ssh_path
    sk_path = Gitti.self_ssh_key_path
    sk_auth_key_path = File.join(Gitti.ssh_path, 'authorized_keys')

    if use_private_key
      sk_path = use_private_key
    else
      sh "ssh-keygen -t rsa -b 2048 -f %s -q -N ''" % sk_path
    end

    sh "ssh-keygen -y -f %s | tee %s" % [ sk_path, sk_auth_key_path ]
    sh 'chmod -R 700 %s' % ssh_path
    sh 'chmod 600 %s' % sk_auth_key_path
  end

  def self.say(msg)
    $stdout.puts msg
  end

  def self.git_repos
    run_opts['repos']
  end

  def self.git_server
    run_opts['git_server']
  end

  def self.var_path
    config.finalize_paths(run_opts['var'])
  end

  def self.ssh_path
    File.join(var_path, '.ssh')
  end

  def self.self_ssh_key_path
    File.join(ssh_path, 'id_rsa')
  end

  def self.run_opts
    gconfig['docker_run']
  end

  def self.gconfig
    config['gitti']
  end

  def self.config
    ::Thomas.config
  end

  def self.in_thomas?
    defined?(THOMAS_ROOT_PATH)
  end
end
