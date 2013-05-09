module Backyard
  class Configuration

    attr_reader :adapter

    def initialize
      @model_configuration ||= {}
      @adapter ||= :factory_girl
    end

    def name_attribute(attribute, options = {})
      raise "missing the :for options" unless options.has_key?(:for)
      [*options[:for]].each do |model_type|
        model = adapter_instance.class_for_type(model_type)
        config_for(model).name_attributes << attribute
      end
    end

    def name_for(*args, &block)
      options = args.extract_options!
      args.each do |model_type|
        klass = adapter_instance.class_for_type(model_type)

        if options.has_key?(:attribute)
          config_for(klass).name_attributes << options[:attribute]
        else
          config_for(klass).name_blocks << block
        end
      end
    end

    def use_adapter(adapter)
      @adapter = adapter
    end

    def config_for(model_type)
      @model_configuration[model_type] ||= Model.new
    end

    def adapter_instance
      @adapter_instance ||= adapter_klass.new
    end

    def adapter_klass
      adapter_name = adapter.to_s.split('_').map!{ |w| w.capitalize }.join

      unless Adapter.const_defined? adapter_name, false
        require File.join('backyard', 'adapter', "#{adapter}")
      end

      Adapter.const_get adapter_name, false
    end
    private :adapter_klass

    class Model
      attr_writer :name_attributes, :name_blocks
      def name_attributes
        @name_attributes ||= []
      end

      def name_blocks
        @name_blocks ||= []
      end
    end

  end
end
