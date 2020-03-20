# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

module RedmineOmniauthSaml
  module TestHelper
    def attribute_mapping_mock
      { 'login' => 'login',
        'firstname' => 'first_name',
        'lastname' => 'last_name',
        'mail' => 'mail',
        'admin' => 'admin' }
    end

    def prepare_tests
      Setting['plugin_redmine_omniauth_saml']['enabled'] = true
      Redmine::OmniAuthSAML.configured_saml[:attribute_mapping] = attribute_mapping_mock
    end
  end

  class ControllerTest < Redmine::ControllerTest
    include RedmineOmniauthSaml::TestHelper
  end

  class TestCase < ActiveSupport::TestCase
    include RedmineOmniauthSaml::TestHelper
  end
end
