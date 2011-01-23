module Backyard
  module Session

    def adapter
      @adapter ||= Backyard.config.adapter_instance
    end

    def put_model(model_type, name = nil, options = {})
      model_name = name.nil? ? Backyard::Session.generate_model_name(model_type) : name
      obj = if model_type.is_a?(String) || model_type.is_a?(Symbol)
              klass = class_for_type(model_type)
              attributes = apply_model_config(klass, model_name).merge(options)
              adapter.create(model_type, attributes)
            else
              model_type
            end
      model_store.put(model_name, obj)
    end

    def get_model(model_type, name)
      klass = class_for_type(model_type)
      result = model_store.get(klass, name)
      reload_model(result)
    end

    def model_exists?(model_type, name)
      get_model(model_type, name) != nil
    end

    def model(model_type, name, attributes = {})
      if model_exists?(model_type, name)
        get_model(model_type, name)
      else
        put_model(model_type, name, attributes)
      end
    end

    def get_models(model_type)
      model_store.get_collection class_for_type(model_type)
    end

    def model_store
      @store ||= ModelStore.new
    end

    def self.generate_model_name(model_type)
      "#{model_type.to_s.capitalize} #{Time.now.to_f}"
    end

    protected

    def reload_model(model)
      if model.respond_to?(:reload)
        model.reload
      else
        model
      end
    end

    def class_for_type(model_type)
      klass = if model_type.kind_of?(Class)
                model_type
              else
                adapter.class_for_type(model_type)
              end
    end

    def apply_model_config(klass, model_name)
      model_config = Backyard.config.config_for(klass)
      name_attributes = model_config.name_attributes.map { |attribute| [attribute, model_name]}
      block_attributes = model_config.name_blocks.inject({}) do |attrs, block|
        attrs.merge(instance_exec model_name, &block)
      end
      Hash[name_attributes].merge(block_attributes)
    end

  end
end
