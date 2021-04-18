# frozen_string_literal: true

require File.expand_path "#{File.dirname __FILE__}/../../../test/test_helper"

module RedmineSAML
  module TestHelper
    def attribute_mapping_mock
      { login: 'saml_login',
        firstname: 'first_name',
        lastname: 'last_name',
        mail: 'mail',
        admin: 'admin' }
    end

    def prepare_tests
      change_saml_settings saml_enabled: 1
      RedmineSAML.configured_saml[:attribute_mapping] = attribute_mapping_mock
    end

    def change_saml_settings(settings)
      @saved_settings = Setting.plugin_redmine_saml.dup
      new_settings = Setting.plugin_redmine_saml.dup
      settings.each do |key, value|
        new_settings[key] = value
      end
      Setting.plugin_redmine_saml = new_settings
    end
  end

  class ControllerTest < Redmine::ControllerTest
    include RedmineSAML::TestHelper
  end

  class TestCase < ActiveSupport::TestCase
    include RedmineSAML::TestHelper
  end
end
