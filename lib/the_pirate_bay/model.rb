module ThePirateBay
  module Model
    
    attr_accessor :klass
    
    def initialize(params=nil)
      @klass = self.class
      self.attributes = params
    end
    
    def attributes=(params=nil)
      params.each do |attr, value|
        begin
          self.public_send("#{klass::ATTRS_MAP.key(attr)}=", value)
        rescue NoMethodError
          raise UnknownAttributeError, "unknown attribute: #{attr}"
        end
      end if params
    end
    
    def attributes
      attrs = {}
      klass::ATTRS_MAP.keys.each do |name|
        attrs[name] = send(name)
      end
      attrs
    end
    
    def inspect
      inspection = unless id.nil?
        klass::ATTRS_MAP.keys.collect { |name|
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