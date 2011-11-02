module Backyard
  module Session

    # Put a model in the backyard.
    #
    # @overload put_model(type, name, attributes)
    #   creates an instance from type 'type' and saved it under the
    #   passed name. The attributes are forwarded to the object creation
    #   @param [Symbol] type
    #   @param [String] name
    #   @param [Hash] attributes additional parameters for the object creation
    # @overload put_model(object, name)
    #   stores the given object under 'name'
    #   @param [Object] object the object to store
    #   @param [String] name
    # @return [Object] the object, which was stored
    def put_model(model_type, name = nil, attributes = {})
      model_name = name.nil? ? adapter.generate_model_name(model_type) : name
      obj = if model_type.is_a?(String) || model_type.is_a?(Symbol)
              klass = class_for_type(model_type)
              attributes = apply_model_config(klass, model_name).merge(attributes)
              adapter.create(model_type, attributes)
            else
              model_type
            end
      model_store.put(model_name, obj)
    end

    # Retrieve a stored object from the backyard.
    #
    # @param [Symbol] model_type
    # @param [String] name
    # @return [Object, nil]
    def get_model(model_type, name)
      klass = class_for_type(model_type)
      result = model_store.get(klass, name) || Backyard.global_store.model_store.get(klass, name)
      if result.nil? && Backyard.name_based_database_lookup
        result = find_model_from_database(klass, name)
        put_model(result, name) if result
        result
      else
        reload_model(result)
      end
    end

    # Check if a model is stored in the backyard.
    #
    # @param [Symbol] model_type
    # @param [String] name
    # @return [true, false]
    def model_exists?(model_type, name)
      get_model(model_type, name) != nil
    end

    # This method is used when you don't care if you get an existing
    # instance or if a new one is beeing created.
    #
    # @see #get_model
    # @see #put_model
    #
    # @param [Symbol] model_type
    # @param [String] name
    # @return [Object]
    def model(model_type, name, attributes = {})
      if model_exists?(model_type, name)
        get_model(model_type, name)
      else
        put_model(model_type, name, attributes)
      end
    end

    # Retrieve all objects for a given type.
    #
    # @param [Symbol] type
    # @return [Array<Object>]
    def get_models(model_type)
      model_store.get_collection class_for_type(model_type)
    end

    def model_store
      @store ||= ModelStore.new
    end

    protected

    def adapter
      @adapter ||= Backyard.config.adapter_instance
    end

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

    def find_model_from_database(klass, model_name)
      model_config = Backyard.config.config_for(klass)
      name_attributes = model_config.name_attributes
      return unless name_attributes.size == 1
      klass.where(name_attributes.first => model_name).first
    end
  end
end
