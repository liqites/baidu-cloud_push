module Baidu
  module Callbacks

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def before_methods(*names)
        names.each do |name|
          m = instance_method(name)
          define_method(name) do |*args,&block|
            yield(__method__.to_s)
            m.bind(self).(*args,&block)
          end
        end
      end

      def after_methods(*names)
        names.each do |name|
          m = instance_method(name)
          define_method(name) do |*args,&block|
            m.bind(self).(*args,&block)
            yield(__method__.to_s)
          end
        end
      end
    end
  end
end
