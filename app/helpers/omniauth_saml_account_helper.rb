module OmniauthSamlAccountHelper
  def saml_login_label
    RedmineSAML.saml_login_label.presence || l(:saml_login_label)
  end

  def saml_url_validate_test(url1, url2)
    url1 == url2 ? image_tag('true.png', title: "#{url1} == #{url2}") : image_tag('false.png', title: "#{url1} != #{url2}")
  end
end
