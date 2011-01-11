require 'backyard/configuration'
require 'backyard/adapter'
require 'backyard/model_store'
require 'backyard/session'

module Backyard
  def self.configure(&block)
    @config = Backyard::Configuration.new
    @config.instance_eval(&block)
  end

  def self.config
    @config ||= Backyard::Configuration.new
    @config
  end
end
