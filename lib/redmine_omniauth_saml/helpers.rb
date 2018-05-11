module Redmine
  module OmniAuthSAML
    module Helpers
      def label_for_saml_login
        Redmine::OmniAuthSAML.label_login_with_saml.presence || l(:label_login_with_saml)
      end

      def saml_url_validate_test(url1, url2)
        if url1 == url2
          image_tag('true.png')
        else
          image_tag('false.png', title: "#{url1} != #{url2}")
        end
      end
    end
  end
end

ActionView::Base.send :include, Redmine::OmniAuthSAML::Helpers
