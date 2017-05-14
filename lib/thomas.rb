require 'docker_task'

module Thomas
  autoload :Config, 'thomas/config'
  autoload :Helper, 'thomas/helper'

  def self.config
    if defined?(@config)
      @config
    else
      @config = Config.load_config
    end
  end

  def self.include_docker_tasks(options = { })
    DockerTask.include_tasks(options)
  end
end
