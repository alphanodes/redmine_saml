module Redmine
  module OmniAuthSAML
    class OmniAuthSAMLHookListener < Redmine::Hook::ViewListener
      render_on :view_account_login_top, partial: 'redmine_omniauth_saml/view_account_login_top'
    end
  end
end
