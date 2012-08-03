class Backyard::Adapter::FactoryGirl < Backyard::Adapter

  def class_for_type(model_type)
    factory = self.class.factory_girl_class.factories[model_type.to_sym]
    raise ArgumentError, "no factory for: #{model_type}\ngot: #{::Factory.factories.keys}" unless factory
    factory.build_class
  end

  def create(model_type, attributes)
    self.class.factory_girl_class.create(model_type, attributes)
  end

  def self.factory_girl_class
    defined?(::FactoryGirl) ? ::FactoryGirl : Factory
  end

end
