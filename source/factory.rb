class Factory
  def self.new(*properties, &block)
    struct_name = (properties[0].is_a? String) ? properties.shift : ''

    clazz = Class.new do
      @properties = properties

      def initialize(*args)
        self.class.properties.each_with_index do |property, index|
          instance_variable_set "@#{property}", args[index]
        end
      end

      def ==(object)
        return (not object.nil?) && self.class.properties.all? do |property|
          eval "#{property} == object.#{property}"
        end
      end

      def [](index)
        index = self.class.properties[index] if index.is_a? Fixnum
        instance_variable_get "@#{index}"
      end

      def []=(index, value)
        index = self.class.properties[index] if index.is_a? Fixnum
        instance_variable_set "@#{index}", value
      end

      def each(&block)
        self.class.properties.each do |property|
          block.call instance_variable_get "@#{property}"
        end
      end

      def each_pair(&block)
        self.class.properties.each do |property|
          block.call property, instance_variable_get("@#{property}")
        end
      end

      def self.properties
        @properties
      end

      properties.each do |property|
        define_method("#{property}") { instance_variable_get "@#{property}" }
        define_method("#{property}=") { |value| instance_variable_set "@#{property}", value }
      end

      class_eval &block if block_given?
    end

    if struct_name.length != 0
      self.const_set "#{struct_name}", clazz
    end

    clazz
  end
end