module Backyard
  class Adapter

    def class_for_type(model_type)
      model_type.to_s.split('_').map!{ |w| w.capitalize }.join
    end

    def generate_model_name(model_type)
      "#{model_type.to_s.capitalize} #{Time.now.to_f}".tap{|s| s << s.object_id.to_s}
    end

    def create(model_type, attributes)
      raise NotImplementedError
    end

  end
end
