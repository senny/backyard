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

    def name_for(*model_types, &block)
      model_types.each do |model_type|
        klass = adapter_instance.class_for_type(model_type)
        config_for(klass).name_blocks << block
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
      adapter_class = "Backyard::Adapter::#{adapter_name}"
      unless eval("defined?(#{adapter_class}) && #{adapter_class}.is_a?(Class)") == true
        require File.join('backyard', 'adapter', "#{adapter}")
      end
      eval adapter_class
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
