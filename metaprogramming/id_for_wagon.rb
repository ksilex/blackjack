module IDIncrementor
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    @@wagon_id = 0

    def wagon_id
      @@wagon_id
    end

    def wagon_id=(val)
      @@wagon_id = val
    end
  end

  module InstanceMethods
    def wagon_id
      @wagon_id
    end

    private

    def id_incrementor
      self.class.wagon_id += 1
      @wagon_id = self.class.wagon_id
    end
  end
end
