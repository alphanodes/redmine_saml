# frozen_string_literal: true

class AddOmniauthSamlAttributeToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :created_by_omniauth_saml, :boolean, default: false, null: false
  end
end
