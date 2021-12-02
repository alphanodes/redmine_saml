# frozen_string_literal: true

module RedmineSaml
  module Hooks
    class SAMLHookListener < Redmine::Hook::ViewListener
      render_on :view_account_login_top, partial: 'saml/view_account_login_top'

      def after_plugins_loaded(_context = {})
        RedmineSaml.setup if Rails.version > '6.0'
      end
    end
  end
end
