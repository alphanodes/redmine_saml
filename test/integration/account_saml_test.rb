# frozen_string_literal: true

require File.expand_path '../../test_helper', __FILE__

class AccountSAMLTest < Redmine::IntegrationTest
  fixtures :users, :groups_users, :email_addresses, :user_preferences, :roles

  include RedmineSaml::TestHelper

  setup do
    prepare_tests
  end

  context 'GET /auth/:provider/callback' do
    context 'OmniAuth SAML strategy' do
      setup do
        Setting.default_language = 'en'
        change_saml_settings saml_enabled: 1,
                             onthefly_creation: 0

        OmniAuth.config.test_mode = true
      end

      should 'authorize login if user exists with this login' do
        OmniAuth.config.mock_auth[:saml] = { 'saml_login' => 'admin' }

        get RedmineSaml::CALLBACK_PATH
        assert_redirected_to '/my/page'

        get '/my/page'
        assert_match(/Logged in as.*admin/im, response.body)
      end

      should 'authorize login if user exists with this mail' do
        OmniAuth.config.mock_auth[:saml] = { 'mail' => 'admin@somenet.foo' }

        get RedmineSaml::CALLBACK_PATH
        assert_redirected_to '/my/page'

        get '/my/page'
        assert_match(/Logged in as.*admin/im, response.body)
      end

      should 'update last_login_on field' do
        user = users :users_001
        user.update_attribute :last_login_on, 6.hours.ago
        OmniAuth.config.mock_auth[:saml] = { 'saml_login' => 'admin' }

        get RedmineSaml::CALLBACK_PATH
        assert_redirected_to '/my/page'
        user.reload
        assert Time.zone.now - user.last_login_on < 30.seconds
      end

      should "refuse login if user doesn't exist" do
        OmniAuth.config.mock_auth[:saml] = { 'saml_login' => 'johndoe' }
        get RedmineSaml::CALLBACK_PATH
        assert_redirected_to '/login'
        follow_redirect!
        assert_equal User.anonymous, User.current
        assert_select 'div.flash.error', text: /Invalid user or password/
      end

      should "create user if doesn't exist when on thefly_creation is set" do
        change_saml_settings onthefly_creation: 1

        login_name = 'johndoe'
        assert_difference 'User.count' do
          OmniAuth.config.mock_auth[:saml] = { 'saml_login' => login_name,
                                               'first_name' => 'first name',
                                               'last_name' => 'last name',
                                               'mail' => 'mail@example.com' }
          get RedmineSaml::CALLBACK_PATH

          assert_redirected_to '/my/page'
          follow_redirect!
        end

        assert User.exists? login: login_name
      end
    end
  end
end
