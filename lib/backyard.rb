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

  def self.global_store
    return @global_store if @global_store
    @global_store = Object.new
    @global_store.extend Backyard::Session
  end
end
