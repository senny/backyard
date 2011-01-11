class Backyard::Adapter::FactoryGirl < Backyard::Adapter

  def class_for_type(model_type)
    ::Factory.factories[model_type.to_sym].build_class
  end

  def create(model_type, attributes)
    Factory(model_type, attributes)
  end

end
