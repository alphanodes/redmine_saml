# frozen_string_literal: true

Rails.application.routes.draw do
  match '/auth/failure' => 'account#login_with_saml_failure',
        via: %i[get post]
  match '/auth/:provider/callback' => 'account#login_with_saml_callback',
        as: :login_with_saml_callback,
        via: %i[get post]
  match '/auth/:provider' => 'account#login_with_saml_redirect',
        as: :login_with_saml_redirect,
        via: %i[get post]
  match '/auth/:provider/sls' => 'account#redirect_after_saml_logout',
        as: :redirect_after_saml_logout,
        via: %i[get post]
end
