class Factory
  def self.new(*properties, &block)
    struct_name = (properties[0].is_a? String) ? properties.shift : ''

    clazz = Class.new do
      attr_accessor *properties

      define_method :initialize do |*args|
        properties.each_with_index do |var, index|
          instance_variable_set "@#{var}", args[index]
        end
      end

      def ==(object)
        return (not object.nil?) && instance_variables.all? do |property|
          instance_variable_get(property) == object.instance_variable_get(property)
        end
      end

      def [](property)
        property = (property.is_a? Fixnum) ? instance_variables[property] : "@#{property}"
        instance_variable_get property
      end

      def []=(property, value)
        property = (property.is_a? Fixnum) ? instance_variables[property] : "@#{property}"
        instance_variable_set property, value
      end

      def each
        instance_variables.each do |property|
          yield instance_variable_get property
        end
      end

      def each_pair
        instance_variables.each do |property|
          yield property, instance_variable_get(property)
        end
      end

      def length
        instance_variables.length
      end

      class_eval &block if block_given?
    end

    if struct_name.length != 0
      self.const_set "#{struct_name}", clazz
    end

    clazz
  end
end