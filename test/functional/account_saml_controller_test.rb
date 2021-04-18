# frozen_string_literal: true

require File.expand_path '../../test_helper', __FILE__

# let's use the existing functional test so we don't have to re-setup everything
# + we are sure that existing tests pass each time we run this file only
require Rails.root.join('test/functional/account_controller_test')

class AccountSamlControllerTest < RedmineSAML::ControllerTest
  fixtures :users, :groups_users, :email_addresses, :user_preferences, :roles

  tests AccountController

  setup do
    prepare_tests
  end

  context 'GET /login SAML button' do
    should "show up only if there's a plugin setting for SAML URL" do
      change_saml_settings saml_enabled: 0
      get :login
      assert_select '#saml-login', 0

      change_saml_settings saml_enabled: 1
      get :login
      assert_select '#saml-login'
    end
  end

  context 'GET login_with_saml_callback' do
    should 'redirect to /my/page after successful login' do
      request.env['omniauth.auth'] = { 'saml_login' => 'admin' }
      get :login_with_saml_callback,
          params: { provider: 'saml' }

      assert_redirected_to '/my/page'
    end

    should 'redirect to /login after failed login' do
      request.env['omniauth.auth'] = { 'saml_login' => 'non-existent' }
      get :login_with_saml_callback,
          params: { provider: 'saml' }

      assert_redirected_to '/login'
    end

    should 'set a boolean in session to keep track of login' do
      request.env['omniauth.auth'] = { 'saml_login' => 'admin' }
      get :login_with_saml_callback,
          params: { provider: 'saml' }

      assert_redirected_to '/my/page'
      assert session[:logged_in_with_saml]
    end

    should 'redirect to Home if not logged in with SAML' do
      get :logout
      assert_redirected_to home_url
    end

    should 'redirect to SAML logout if previously logged in with SAML' do
      RedmineSAML.configured_saml[:signout_url] = 'https://saml.server/logout?return='
      RedmineSAML.configured_saml[:idp_slo_target_url] = 'https://saml.server/ls/?wa=wsignout1'
      session[:logged_in_with_saml] = true

      get :logout
      assert_response :redirect
      assert_match(/#{Regexp.escape RedmineSAML.configured_saml[:idp_slo_target_url]}.*http%3A%2F%2Ftest\.host%2F/,
                   @response.redirect_url)
    end
  end
end
