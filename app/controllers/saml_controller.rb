class SamlController < ApplicationController
  # prevents login action to be filtered by check_if_login_required application scope filter
  skip_before_action :check_if_login_required, :check_password_change

  def metadata
    return render_404 unless Additionals.true?(saml_settings['enabled'])

    settings = OneLogin::RubySaml::Settings.new omniauth_saml_settings
    metadata = OneLogin::RubySaml::Metadata.new
    output = metadata.generate settings
    render plain: output, content_type: 'application/xml'
  end

  private

  def saml_settings
    Redmine::OmniAuthSAML.settings_hash
  end

  def omniauth_saml_settings
    Redmine::OmniAuthSAML.configured_saml
  end
end
