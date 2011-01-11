module Backyard
  class Adapter

    def class_for_type(model_type)
      model_type.to_s.split('_').map!{ |w| w.capitalize }.join
    end

    def create(model_type, attributes)
      raise NotImplementedError
    end

  end
end
