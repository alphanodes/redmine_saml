module RedmineSAML
  module Patches
    module SettingsControllerPatch
      extend ActiveSupport::Concern

      included do
        helper :omniauth_saml_account
      end
    end
  end
end
