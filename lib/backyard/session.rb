module Backyard
  module Session

    def adapter
      @adapter ||= Backyard.config.adapter_instance
    end

    def put_model(model_type, name = nil, options = {})
      model_name = name.nil? ? Backyard::Session.generate_model_name(model_type) : name
      klass = adapter.class_for_type(model_type)
      obj = if options.is_a?(Hash)
              model_config = Backyard.config.config_for(klass)
              name_attributes = model_config.name_attributes.map { |attribute| [attribute, model_name]}
              block_attributes = model_config.name_blocks.inject({}) do |attrs, block|
          attrs.merge(instance_exec model_name, &block)
        end
              attributes = Hash[name_attributes].merge(block_attributes).merge(options)
              adapter.create(model_type, attributes)
            else
              options
            end
      model_store.put(model_name, obj)
    end

    def put_instance(name, obj)
      model_store.put(name, obj)
    end

    def get_model(model_type, name)
      klass = if model_type.kind_of?(Class)
                model_type
              else
                adapter.class_for_type(model_type)
              end
      result = model_store.get(klass, name)
      if result.respond_to?(:reload)
        result.reload
      else
        result
      end
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

    def model_store
      @store ||= ModelStore.new
    end

    def self.generate_model_name(model_type)
      "#{model_type.to_s.capitalize} #{Time.now.to_f}"
    end

  end
end
