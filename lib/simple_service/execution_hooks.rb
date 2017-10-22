module SimpleService
  module ExecutionHooks
    def method_added(method_name)
      # do nothing if the method isnt a hook target
      # or if it already had hooks added to it
      return if [
        hooked_methods.include?(method_name),
        !methods_to_hook.keys.include?(method_name)
      ].any?

      add_hooks_to(method_name)
    end

    def before_hook(target_method_name, callback_name)
      hook(target_method_name, callback_name, :before)
    end

    def after_hook(target_method_name, callback_name)
      hook(target_method_name, callback_name, :after)
    end

    private

    def hook(target_method_name, callback_name, ordering)
      methods_to_hook[target_method_name] ||= {}
      methods_to_hook[target_method_name][ordering] ||= []
      methods_to_hook[target_method_name][ordering] << callback_name
    end

    def methods_to_hook
      @method_to_hook ||= {}
    end

    # keeps track of all currently hooked methods
    def hooked_methods
      @hooked_methods ||= []
    end

    def add_hooks_to(method_name)
      if methods_to_hook.keys.include?(method_name)
        hooked_methods << method_name
        original_method = instance_method(method_name)

        # re-define the method
        define_method(method_name) do |**kwargs, &block|
          targets_hooks = self.class.send(:methods_to_hook)[method_name]

          target_before_hooks = targets_hooks.fetch(:before)

          if target_before_hooks
            target_before_hooks.each do |hook|
              kwargs = method(hook).call(self, **kwargs)
            end
          end

          # now invoke the original method
          result = original_method.bind(self).call(**kwargs, &block)

          target_after_hooks = targets_hooks.fetch(:after)

          if target_after_hooks
            target_after_hooks.each do |hook|
              result = method(hook).call(self, result)
            end
          end

          result
        end
      end
    end
  end
end
