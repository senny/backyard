module Backyard
  class ModelStore

    def initialize
      @store ||= {}
    end

    def put(name, object)
      @store[object.class] ||= {}
      @store[object.class][name] = object
    end

    def get(klass, name)
      models = @store[klass]
      unless models.nil?
        models[name]
      end
    end
  end # END ModelStore
end # END Backyard
