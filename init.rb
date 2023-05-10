# frozen_string_literal: true

loader = RedminePluginKit::Loader.new plugin_id: 'redmine_saml'

Redmine::Plugin.register :redmine_saml do
  name 'Redmine SAML'
  description 'This plugin adds Omniauth SAML support to Redmine.'
  author 'AlphaNodes GmbH'
  author_url 'https://alphanodes.com/'
  url 'https://github.com/alphanodes/redmine_saml'
  version RedmineSaml::VERSION
  requires_redmine version_or_higher: '5.0'

  begin
    requires_redmine_plugin :additionals, version_or_higher: '3.0.9'
  rescue Redmine::PluginNotFound
    raise 'Please install additionals plugin (https://github.com/alphanodes/additionals)'
  end

  settings default: loader.default_settings,
           partial: 'saml/settings/saml'
end

RedminePluginKit::Loader.persisting { loader.load_model_hooks! }
