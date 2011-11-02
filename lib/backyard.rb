require 'backyard/configuration'
require 'backyard/adapter'
require 'backyard/model_store'
require 'backyard/session'

module Backyard
  class << self
    attr_writer :name_based_database_lookup
  end

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

  def self.name_based_database_lookup
    @name_based_database_lookup || false
  end

  def self.reset_name_based_database_lookup
    @name_based_database_lookup = false
  end
end
