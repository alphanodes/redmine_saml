# frozen_string_literal: true

module RedmineSaml
  VERSION = '1.0.6'

  METADATA_PATH = '/auth/saml/metadata'
  CALLBACK_PATH = '/auth/saml/callback'
  LOGOUT_SERVICE_PATH = '/auth/saml/sls'

  include RedminePluginKit::PluginBase

  class << self
    def enabled?
      setting? :saml_enabled
    end

    def onthefly_creation?
      enabled? && setting?(:onthefly_creation)
    end

    def replace_redmine_login?
      setting? :replace_redmine_login
    end

    def saml_login_label
      setting :saml_login_label
    end

    def user_attributes_from_saml(omniauth)
      Base.user_attributes_from_saml omniauth
    end

    def configured_saml
      Base.configured_saml
    end

    def on_login_callback
      Base.on_login_callback
    end

    private

    def setup
      # Patches
      loader.add_patch %w[User
                          AccountController
                          SettingsController]

      # Apply patches and helper
      loader.apply!

      # Load view hooks
      loader.load_view_hooks!
    end
  end
end
