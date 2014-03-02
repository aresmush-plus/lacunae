module AresMUSH
  module Plugin
    def self.included(base)
      base.send :extend, PluginValidators
    end

    module PluginValidators
      def must_be_logged_in
        send :define_method, "validate_check_for_login" do
          return t('dispatcher.must_be_logged_in') if !client.logged_in?
          return nil
        end
      end
      
      def no_args
        send :define_method, "validate_no_args" do
          return t('dispatcher.cmd_no_switches_or_args') if !cmd.args.nil?
          return nil
        end
      end

      def no_switches
        send :define_method, "validate_no_switches" do
          return t('dispatcher.cmd_no_switches') if !cmd.switch.nil?
          return nil
        end
      end
    end
  end
end