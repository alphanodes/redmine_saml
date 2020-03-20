require_dependency 'redmine_omniauth_saml'

Redmine::Plugin.register :redmine_omniauth_saml do
  name 'Redmine Omniauth SAML plugin'
  description 'This plugin adds Omniauth SAML support to Redmine.'
  author 'Christian A. Rodriguez, Alexander Meindl'
  url 'https://github.com/alexandermeindl/redmine_omniauth_saml'
  version '0.9.11'
  requires_redmine version_or_higher: '4.0'
  settings default: { 'enabled' => 'true', 'label_login_with_saml' => '', 'replace_redmine_login' => false },
           partial: 'settings/omniauth_saml/omniauth_saml'

  begin
    requires_redmine_plugin :additionals, version_or_higher: '2.0.23'
  rescue Redmine::PluginNotFound
    raise 'Please install additionals plugin (https://github.com/alphanodes/additionals)'
  end
end

if ActiveRecord::Base.connection.table_exists?(:settings)
  Rails.configuration.to_prepare do
    Redmine::OmniAuthSAML.setup
  end
end
