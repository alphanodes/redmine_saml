# frozen_string_literal: true

require_dependency 'redmine_saml'

Redmine::Plugin.register :redmine_saml do
  name 'Redmine SAML'
  description 'This plugin adds Omniauth SAML support to Redmine.'
  author 'AlphaNodes GmbH'
  author_url 'https://alphanodes.com/'
  url 'https://github.com/alphanodes/redmine_saml'
  version RedmineSAML::VERSION
  requires_redmine version_or_higher: '4.1'

  begin
    requires_redmine_plugin :additionals, version_or_higher: '3.0.1'
  rescue Redmine::PluginNotFound
    raise 'Please install additionals plugin (https://github.com/alphanodes/additionals)'
  end

  settings default: Additionals.load_settings('redmine_saml'),
           partial: 'saml/settings/saml'
end

Rails.configuration.to_prepare do
  RedmineSAML.setup
end
