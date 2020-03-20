require File.expand_path('../../test_helper', __FILE__)

class AccountHelperTest < Redmine::HelperTest
  include OmniauthSamlAccountHelper
  include Redmine::I18n

  context '#label_for_saml_login' do
    should 'use label_login_with_saml plugin setting if not blank' do
      label = 'Login with SSO'
      Setting['plugin_redmine_omniauth_saml']['label_login_with_saml'] = label
      assert_equal label, label_for_saml_login
    end

    should 'default to localized :label_login_with_saml if no setting present' do
      assert_equal l(:label_login_with_saml), label_for_saml_login
    end
  end
end
