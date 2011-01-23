class Backyard::Adapter::FactoryGirl < Backyard::Adapter

  def class_for_type(model_type)
    factory = ::Factory.factories[model_type.to_sym]
    raise ArgumentError, "no factory for: #{model_type}\ngot: #{::Factory.factories.keys}" unless factory
    factory.build_class
  end

  def create(model_type, attributes)
    Factory(model_type, attributes)
  end

end
