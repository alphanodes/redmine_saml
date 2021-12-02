# frozen_string_literal: true

raise "\n\033[31maredmine_saml requires ruby 2.6 or newer. Please update your ruby version.\033[0m" if RUBY_VERSION < '2.6'

require 'redmine_saml'

Redmine::Plugin.register :redmine_saml do
  name 'Redmine SAML'
  description 'This plugin adds Omniauth SAML support to Redmine.'
  author 'AlphaNodes GmbH'
  author_url 'https://alphanodes.com/'
  url 'https://github.com/alphanodes/redmine_saml'
  version RedmineSaml::VERSION
  requires_redmine version_or_higher: '4.1'

  begin
    requires_redmine_plugin :additionals, version_or_higher: '3.0.3'
  rescue Redmine::PluginNotFound
    raise 'Please install additionals plugin (https://github.com/alphanodes/additionals)'
  end

  settings default: AdditionalsLoader.default_settings('redmine_saml'),
           partial: 'saml/settings/saml'
end

AdditionalsLoader.load_hooks! 'redmine_saml'
AdditionalsLoader.to_prepare { RedmineSaml.setup } if Rails.version < '6.0'
