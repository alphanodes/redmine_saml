require_dependency 'user'

module OmniAuthSamlUser
  def self.prepended(base)
    class << base
      prepend(OmniAuthSamlUserMethods)
    end
  end

  module OmniAuthSamlUserMethods
    def find_or_create_from_omniauth(omniauth)
      user_attributes = Redmine::OmniAuthSAML.user_attributes_from_saml omniauth

      user = nil
      user = find_by_login(user_attributes[:login]) if user_attributes[:login].present? # rubocop:disable Rails/DynamicFindBy
      user = EmailAddress.find_by(address: user_attributes[:mail]).try(:user) if user.nil?

      if user.nil? && Redmine::OmniAuthSAML.onthefly_creation?
        user = new user_attributes
        user.created_by_omniauth_saml = true
        user.login = user_attributes[:login].presence || user_attributes[:mail]
        user.language = Setting.default_language
        user.activate
        user.save!
        user.reload
      end

      unless user.nil?
        user.firstname = user_attributes[:firstname]
        user.lastname = user_attributes[:lastname]
        user.admin = user_attributes[:admin] if user_attributes[:admin].present?
        Redmine::OmniAuthSAML.on_login_callback&.call(omniauth, user)
      end
      user
    end
  end

  def change_password_allowed?
    super && !created_by_omniauth_saml?
  end
end

User.prepend(OmniAuthSamlUser)
