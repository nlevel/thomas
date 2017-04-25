module Reddys
  EXPOSED_PORT = 6379
  DURABLE_EXPOSED_PORT = 6380

  REDDYS_APP_PATH = '/opt/services/reddys'

  def self.app_path(use_docker = false)
    if use_docker || in_docker?
      if ENV.include?('REDDYS_APP_PATH')
        File.expand_path(ENV['REDDYS_APP_PATH'])
      else
        File.expand_path(REDDYS_APP_PATH)
      end
    else
      File.expand_path('../../', __FILE__)
    end
  end

  def self.var_path(use_docker = false)
    if use_docker || in_docker?
      if ENV.include?('REDDYS_VAR_PATH')
        File.expand_path(ENV['REDDYS_VAR_PATH'])
      else
        File.join(app_path(use_docker), 'var')
      end
    else
      config.finalize_paths(run_opts['var'])
    end
  end

  def self.rconfig
    config['reddys']
  end

  def self.run_opts
    rconfig['docker_run']
  end

  def self.config
    ::Thomas.config
  end

  def self.in_docker?
    ENV.include?('REDDYS_IN_DOCKER')
  end

  def self.in_thomas?
    defined?(THOMAS_ROOT_PATH)
  end
end
