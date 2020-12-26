require File.expand_path '../../test_helper', __FILE__

class RoutingTest < Redmine::RoutingTest
  test 'routing GET /auth/:provider' do
    should_route 'GET /auth/blah' => 'account#login_with_saml_redirect', provider: 'blah'
  end

  test 'routing GET /auth/:provider/callback' do
    should_route 'GET /auth/blah/callback' => 'account#login_with_saml_callback', provider: 'blah'
  end

  test 'routing saml' do
    should_route 'GET /auth/failure' => 'account#login_with_saml_failure'
    should_route 'GET /auth/blah/sls' => 'account#redirect_after_saml_logout', provider: 'blah'
    should_route 'GET /saml/metadata' => 'samls#metadata'
  end
end
