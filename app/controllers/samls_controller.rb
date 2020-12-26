class SamlsController < ApplicationController
  # prevents login action to be filtered by check_if_login_required application scope filter
  skip_before_action :check_if_login_required, :check_password_change

  def metadata
    return render_404 unless RedmineSAML.enabled?

    metadata = OneLogin::RubySaml::Metadata.new
    output = metadata.generate OneLogin::RubySaml::Settings.new(RedmineSAML.configured_saml)
    render plain: output, content_type: 'application/xml'
  end
end
