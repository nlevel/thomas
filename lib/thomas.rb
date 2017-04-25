module Thomas
  autoload :Config, 'thomas/config'
  autoload :DockerTask, 'thomas/docker_task'
  autoload :Helper, 'thomas/helper'

  def self.config
    if defined?(@config)
      @config
    else
      @config = Config.load_config
    end
  end

  def self.include_docker_tasks(options = { })
    DockerTask.new(options).define!
  end
end
