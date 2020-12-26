RedmineSAML::Base.configure do |config|
  config.saml = {
    assertion_consumer_service_url: 'http://localhost/auth/saml/callback',
    idp_cert_fingerprint: '21:4D:FE:12:3A:83:69:A7:12:66:A4:B0:5D:E6:64:96:EF:26:07:2A',
    idp_slo_target_url: 'https://adfs.myserver.com/adfs/ls/?wa=wsignout1.0',
    idp_sso_target_url: 'https://adfs.myserver.com/adfs/ls',
    issuer: 'http://localhost/saml/metadata',
    name_identifier_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:email',
    name_identifier_value: 'email',
    single_logout_service_url: 'http://localhost/auth/saml/sls',
    attribute_mapping: {
      username: 'extra|raw_info|NameID',
      login: 'extra|raw_info|username',
      mail: 'extra|raw_info|emailaddress',
      firstname: 'extra|raw_info|givenname',
      lastname: 'extra|raw_info|surname',
      email: 'extra|raw_info|emailaddress'
    }
  }
end
