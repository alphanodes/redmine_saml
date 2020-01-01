module Redmine
  module OmniAuthSAML
    module UserPatch
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method :change_password_allowed_without_omniauth_saml?, :change_password_allowed?
          alias_method :change_password_allowed?, :change_password_allowed_with_omniauth_saml?
        end
      end

      module ClassMethods
        def find_or_create_from_omniauth(omniauth)
          user_attributes = Redmine::OmniAuthSAML.user_attributes_from_saml omniauth
          user = find_by(login: user_attributes[:login])
          unless user
            user = EmailAddress.find_by(address: user_attributes[:mail]).try(:user)
            if user.nil? && Redmine::OmniAuthSAML.onthefly_creation?
              user = new user_attributes
              user.created_by_omniauth_saml = true
              user.login    = user_attributes[:login]
              user.language = Setting.default_language
              user.activate
              user.save!
              user.reload
            end
          end
          Redmine::OmniAuthSAML.on_login_callback&.call(omniauth, user)
          user
        end
      end

      module InstanceMethods
        def change_password_allowed_with_omniauth_saml?
          change_password_allowed_without_omniauth_saml? && !created_by_omniauth_saml?
        end
      end
    end
  end
end

User.include(Redmine::OmniAuthSAML::UserPatch) unless User.included_modules.include? Redmine::OmniAuthSAML::UserPatch
