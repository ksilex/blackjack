module ValidChecker
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(attr = 0, type = 0, optional = 0)
      @validations ||= []
      @validations.push({ attr: attr, type: type, optional: optional })
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def validate!
      self.class.validations.each do |validation|
        var = instance_variable_get("@#{validation[:attr]}".to_sym)
        send validation[:type].to_sym, var, validation[:optional]
      end
    end

    def presence(var, _pass)
      raise 'Атрибут не может быть пустым' if var.to_s.empty?
    end

    def format(var, regex)
      raise 'Неверный формат' if var !~ regex
    end

    def type(var, type)
      raise 'Неверный тип данных' if var.class != type
    end

    def endpoints(endpoints, _pass)
      unless endpoints.all? { |obj| obj.instance_of?(Station) }
        raise 'Не корректно составлен маршрут'
      end
    end

    def endpoints_differ(endpoints, _pass)
      raise 'Начало и конец маршрута не могут быть одинаковы' if endpoints.first == endpoints.last
    end
  end
end
