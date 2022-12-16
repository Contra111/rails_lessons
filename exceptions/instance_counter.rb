module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods

    def instances
      @instances ||= 0
    end

    private

    def inc_instances
      @instances = instances + 1
    end

  end

  module InstanceMethods

    def register_instance
      self.class.send :inc_instances
    end

  end

end