module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_name_history = "@#{name}_history".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}_history") { instance_variable_get(var_name_history) }
      define_method("#{name}=".to_sym) do |value|
        inst_history = instance_variable_get(var_name_history) || []
        instance_variable_set(var_name, value)
        instance_variable_set(var_name_history, inst_history.push(value))
      end
    end
  end

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise 'Неверный тип' if value.class != type

      instance_variable_set(var_name, value)
    end
  end
end
