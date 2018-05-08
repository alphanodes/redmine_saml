# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match '/auth/failure'             => 'account#login_with_saml_failure',   via: %i[get post]
match '/auth/:provider/callback'  => 'account#login_with_saml_callback',  as: :saml_callback, via: %i[get post]
match '/auth/:provider'           => 'account#login_with_saml_redirect',  as: :sign_in, via: %i[get post]
match '/auth/:provider/sls'       => 'account#redirect_after_saml_logout', as: :sign_out, via: %i[get post]
match '/saml/metadata'            => 'saml#metadata', as: :saml_metadata, via: %i[get]
