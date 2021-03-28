# frozen_string_literal: true

require File.expand_path '../../test_helper', __FILE__

class AccountHelperTest < Redmine::HelperTest
  include OmniauthSamlAccountHelper
  include Redmine::I18n

  context '#saml_login_label' do
    should 'use saml_login_label plugin setting if not blank' do
      label = 'Login with SSO'
      change_saml_settings saml_login_label: label
      assert_equal label, saml_login_label
    end

    should 'default to localized :saml_login_label if no setting present' do
      assert_equal l(:saml_login_label), saml_login_label
    end
  end
end
