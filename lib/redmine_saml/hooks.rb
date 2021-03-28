# frozen_string_literal: true

module RedmineSAML
  class SAMLHookListener < Redmine::Hook::ViewListener
    render_on :view_account_login_top, partial: 'saml/view_account_login_top'
  end
end
