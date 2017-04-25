require 'rubygems'

ROOT_PATH = THOMAS_ROOT_PATH = File.expand_path('../..', __FILE__)

begin
  bundler_setup = true

  if defined?(BUNDLE_GEMFILE)
    if BUNDLE_GEMFILE.nil?
      bundler_setup = false
    else
      ENV['BUNDLE_GEMFILE'] = BUNDLE_GEMFILE
    end
  else
    ENV['BUNDLE_GEMFILE'] = File.join(ROOT_PATH, 'Gemfile')
  end

  if bundler_setup
    begin
      require 'rubygems'
      require 'bundler'
    rescue LoadError
      raise 'Could not load the bundler gem. Install it with `gem install bundler`.'
    rescue Bundler::GemNotFound
      raise RuntimeError, 'Bundler load failed.'
    end

    Bundler.setup
  end
end

module Boboot
  def self.root_path; ROOT_PATH; end

  def self.require_relative_gem(gem_name, lib_path)
    require File.join(self.root_path, '..', gem_name, 'lib', lib_path)
  end

  def self.require_boot!
    require File.join(self.root_path, 'config/boot')
  end

  def self.disable_rubygem_warns
    # Disables Rubygems warnings, as otherwise this is totally out of control
    if (defined?(Deprecate))
      Deprecate.skip = true
    elsif (defined?(Gem::Deprecate))
      Gem::Deprecate.skip = true
    end
  end

  def self.silence_warns
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    result
  end
end

Boboot.disable_rubygem_warns
