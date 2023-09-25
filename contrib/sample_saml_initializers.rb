# frozen_string_literal: true

require Rails.root.join('plugins/redmine_saml/lib/redmine_saml')
require Rails.root.join('plugins/redmine_saml/lib/redmine_saml/base')

RedmineSaml::Base.configure do |config|
  config.saml = {
    # Redmine callback URL
    assertion_consumer_service_url: "http://redmine.example.com#{RedmineSaml::CALLBACK_PATH}",
    # The issuer name / entity ID. Must be an URI as per SAML 2.0 spec.
    # sp_entity_id: 'http://redmine.example.com/auth/saml/metadata' or
    sp_entity_id: "http://redmine.example.com#{RedmineSaml::METADATA_PATH}",
    # The SLS (logout) callback URL
    single_logout_service_url: "http://redmine.example.com#{RedmineSaml::LOGOUT_SERVICE_PATH}",
    # SSO login endpoint
    idp_sso_service_url: 'https://sso.desarrollo.unlp.edu.ar/saml2/idp/SSOService.php',
    # SSO SSL certificate SHA-1 fingerprint
    # NOTE: only use idp_cert OR idp_cert_fingerprint (not both!)
    idp_cert_fingerprint: 'certificate fingerprint',
    # Alternatively, specify the full certifiate
    # NOTE: only use idp_cert OR idp_cert_fingerprint (not both!)
    idp_cert: '-----BEGIN CERTIFICATE-----
CONTENT_OF_CERT_IN_ONE_LINE_WITHOUT_LINE_BREAKS_AND_WITHOUT_BACKSLASH_N
-----END CERTIFICATE-----',
    name_identifier_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent',
    # Optional signout URL, not supported by all identity providers
    signout_url: 'https://sso.example.com/saml2/idp/SingleLogoutService.php?ReturnTo=',
    idp_slo_service_url: 'https://sso.example.com/saml2/idp/SingleLogoutService.php',
    # Which redmine field is used as name_identifier_value for SAML logout
    name_identifier_value: 'mail',
    # overwrite mapping seperator, if required
    # attribute_mapping_sep: '|',
    attribute_mapping: {
      # How will we map attributes from SSO to redmine attributes
      # using either urn:oid:identifier, or friendly names, e.g.
      # mail: 'extra|raw_info|urn:oid:0.9.2342.19200300.100.1.3'
      # or
      # mail: 'extra|raw_info|email'
      #
      # Edit defaults below to match your attributes
      login: 'extra|raw_info|username',
      mail: 'extra|raw_info|email',
      firstname: 'extra|raw_info|firstname',
      lastname: 'extra|raw_info|firstname',
      admin: 'extra|raw_info|admin'
    }
  }

  config.on_login do |omniauth_hash, user|
    # Implement any hook you want here
  end
end
