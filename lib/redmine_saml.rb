require 'redmine_saml/version'

module RedmineSAML
  METADATA_PATH = '/auth/saml/metadata'.freeze

  class << self
    def setup
      User.include RedmineSAML::Patches::UserPatch
      AccountController.include RedmineSAML::Patches::AccountControllerPatch
      SettingsController.include RedmineSAML::Patches::SettingsControllerPatch

      require_dependency 'redmine_saml/hooks'
    end

    # support with default setting as fall back
    def setting(value)
      if settings.key? value
        settings[value]
      else
        Additionals.load_settings('redmine_saml')[value]
      end
    end

    def setting?(value)
      Additionals.true?(settings[value])
    end

    def enabled?
      setting? :enabled
    end

    def onthefly_creation?
      enabled? && setting?(:onthefly_creation)
    end

    def replace_redmine_login?
      setting? :replace_redmine_login
    end

    def label_login_with_saml
      setting :label_login_with_saml
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

  class Base
    class << self
      attr_reader :saml

      def on_login(&block)
        @block = block
      end

      def on_login_callback
        @block ||= nil # rubocop: disable Naming/MemoizedInstanceVariableName
      end

      def saml=(val)
        @saml = HashWithIndifferentAccess.new(val)
      end

      def configured_saml
        raise_configure_exception unless validated_configuration?
        saml
      end

      def configure(&block)
        raise_configure_exception if block.nil?
        yield self
        validate_configuration!
      end

      def user_attributes_from_saml(omniauth)
        HashWithIndifferentAccess.new.tap do |h|
          required_attribute_mapping.each do |symbol|
            key = configured_saml[:attribute_mapping][symbol]
            # binding.pry
            h[symbol] = key.split('|') # Get an array with nested keys: name|first will return [name, first]
                           .map { |x| [:[], x.to_sym] } # Create pair elements being :[] symbol and the key
                           .inject(omniauth.deep_symbolize_keys) do |hash, params|
                             hash&.send(*params) # For each key, apply method :[] with key as parameter
                           end
          end
        end
      end

      private

      def validated_configuration?
        @validated_configuration ||= false
      end

      def required_attribute_mapping
        %i[login firstname lastname mail]
      end

      def validate_configuration!
        %i[assertion_consumer_service_url
           issuer
           idp_sso_target_url
           name_identifier_format
           idp_slo_target_url
           name_identifier_value
           attribute_mapping].each do |k|
          raise "RedmineSAML.configure requires saml.#{k} to be set" unless saml[k]
        end

        unless saml[:idp_cert_fingerprint] || saml[:idp_cert]
          raise 'RedmineSAML.configure requires either saml.idp_cert_fingerprint or saml.idp_cert to be set'
        end

        required_attribute_mapping.each do |k|
          raise "RedmineSAML.configure requires saml.attribute_mapping[#{k}] to be set" unless saml[:attribute_mapping][k]
        end

        raise 'RedmineSAML on_login must be a Proc only' if on_login_callback && !on_login_callback.is_a?(Proc)

        @validated_configuration = true

        configure_omniauth_saml_middleware
      end

      def raise_configure_exception
        raise 'RedmineSAML must be configured from an initializer. See README of redmine_saml for instructions'
      end

      def configure_omniauth_saml_middleware
        saml_options = configured_saml
        Rails.application.config.middleware.use ::OmniAuth::Builder do
          provider :saml, saml_options
        end
      end
    end
  end
end
