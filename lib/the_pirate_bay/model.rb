module ThePirateBay
  module Model
    
    def attributes
      attrs = {}
      class_attributes.each do |name|
        attrs[name] = send(name)
      end
      attrs
    end
    
    def inspect
      inspection = unless id.nil?
        class_attributes.collect { |name|
          "#{name}: #{attribute_for_inspect(name)}"
        }.compact.join(", ")
       else
         "not initialized"
       end
      "#<#{self.class} #{inspection}>"
    end
    
    def attribute_for_inspect(attr_name)
      value = send(attr_name)

      if value.is_a?(String) && value.length > 50
        "#{value[0..50]}...".inspect
      elsif value.is_a?(Date) || value.is_a?(Time)
        %("#{value.to_s(:db)}")
      else
        value.inspect
      end
    end
    
  end # Model
end # ThePirateBay