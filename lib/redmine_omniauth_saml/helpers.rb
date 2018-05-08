module RedmineOmniauthSaml
  module Helpers
    def saml_url_validate_test(url1, url2)
      if url1 == url2
        image_tag('true.png')
      else
        image_tag('false.png', title: "#{url1} != #{url2}")
      end
    end
  end
end

ActionView::Base.send :include, RedmineOmniauthSaml::Helpers
