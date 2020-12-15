module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    @@count = 0

    def count
      @@count
    end

    def count=(val)
      @@count = val
    end

    alias instances count
  end

  module InstanceMethods
    private

    def register_instance
      self.class.count += 1
    end
  end
end
