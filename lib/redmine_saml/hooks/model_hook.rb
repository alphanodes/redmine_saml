# frozen_string_literal: true

module RedmineSaml
  module Hooks
    class ModelHook < Redmine::Hook::Listener
      def after_plugins_loaded(_context = {})
        RedmineSaml.setup!
      end
    end
  end
end
