require 'redmine'
require 'redmine_omniauth_saml'
require 'redmine_omniauth_saml/hooks'
require 'redmine_omniauth_saml/user_patch'
require 'redmine_omniauth_saml/helpers'

# Patches to existing classes/modules
ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_omniauth_saml/account_helper_patch'
  require_dependency 'redmine_omniauth_saml/account_controller_patch'
end

# Plugin generic informations
Redmine::Plugin.register :redmine_omniauth_saml do
  name 'Redmine Omniauth SAML plugin'
  description 'This plugin adds Omniauth SAML support to Redmine.'
  author 'Christian A. Rodriguez, Alexander Meindl'
  url 'https://github.com/alexandermeindl/redmine_omniauth_saml'
  version '0.9.9'
  requires_redmine version_or_higher: '3.4'
  settings default: { 'enabled' => 'true', 'label_login_with_saml' => '', 'replace_redmine_login' => false },
           partial: 'settings/omniauth_saml/omniauth_saml'
end
