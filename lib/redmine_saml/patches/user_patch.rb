# frozen_string_literal: true

module RedmineSaml
  module Patches
    module UserPatch
      extend ActiveSupport::Concern

      included do
        prepend InstanceOverwriteMethods
      end

      class_methods do
        def find_or_create_from_omniauth(omniauth)
          user_attributes = RedmineSaml.user_attributes_from_saml omniauth
          # Additionals.debug "user_attributes: #{user_attributes.inspect}"

          user = nil
          user = find_by_login user_attributes[:login] if user_attributes[:login].present?
          user = EmailAddress.find_by(address: user_attributes[:mail]).try(:user) if user.nil?

          if user.nil? && RedmineSaml.onthefly_creation? && user_attributes[:mail].present?
            Rails.logger.info "SAML onthefly user creation for: #{user_attributes[:mail]}"
            user = new user_attributes
            user.created_by_omniauth_saml = true
            user.login = user_attributes[:login].presence || user_attributes[:mail]
            user.language = Setting.default_language
            user.activate
            if user_attributes[:admin].present?
              user.admin = user_attributes[:admin]
            else
              user.admin = 'false'
            end

            user.save!
            user.reload
          end

          unless user.nil?
            user.firstname = user_attributes[:firstname] if user_attributes[:firstname].present?
            user.lastname = user_attributes[:lastname] if user_attributes[:lastname].present?
            user.admin = user_attributes[:admin] if user_attributes[:admin].present?
          end

          # Debug : check attributes retrueved by the RedmineSaml.user_attributes_from_saml method
          # File.write('/tmp/attributes.txt', user_attributes)


          
          RedmineSaml.on_login_callback&.call omniauth, user

          user
        end
      end

      module InstanceOverwriteMethods
        def change_password_allowed?
          super && !created_by_omniauth_saml?
        end
      end
    end
  end
end
