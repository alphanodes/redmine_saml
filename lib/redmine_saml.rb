# frozen_string_literal: true

module RedmineSaml
  VERSION = '1.0.2'
  METADATA_PATH = '/auth/saml/metadata'

  class << self
    def setup
      loader = AdditionalsLoader.new plugin_id: 'redmine_saml'

      # Patches
      loader.add_patch %w[User
                          AccountController
                          SettingsController]

      # Apply patches and helper
      loader.apply!
    end

    # support with default setting as fall back
    def setting(value)
      if settings.key? value
        settings[value]
      else
        AdditionalsLoader.default_settings('redmine_saml')[value]
      end
    end

    def setting?(value)
      Additionals.true? settings[value]
    end

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

    def settings
      Setting[:plugin_redmine_saml]
    end
  end
end
