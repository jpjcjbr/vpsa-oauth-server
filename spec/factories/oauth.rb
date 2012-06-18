require File.expand_path(File.dirname(__FILE__) + '/../support/settings_helper')
include SettingsHelper

FactoryGirl.define do

  factory :user do
     email "alice@example.com"
     password "example"
     uri USER_URI
     admin false
  end

  factory :user_bob, class: User do
     email "bob@example.com"
     password "example"
     uri ANOTHER_USER_URI
     admin false
  end

  factory :admin, class: User do
     email "admin@example.com"
     password "example"
     uri ADMIN_URI
     admin true
  end

  factory :oauth_access do
    client_uri CLIENT_URI
    resource_owner_uri USER_URI
  end


  factory :oauth_authorization do
    client_uri CLIENT_URI
    resource_owner_uri USER_URI
    scope ALL_SCOPE
  end


  factory :oauth_token do
    client_uri CLIENT_URI
    resource_owner_uri USER_URI
    scope ALL_SCOPE
  end
  
  factory :oauth_token_read, parent: :oauth_token do
    scope READ_SCOPE
  end


  factory :client do
    uri CLIENT_URI
    name "the client"
    created_from USER_URI
    redirect_uri REDIRECT_URI
    scope ["entidades"]
    scope_values ALL_SCOPE
  end

  factory :client_read, parent: :client do
    uri ANOTHER_CLIENT_URI
    scope ["entidades/read"]
    scope_values READ_SCOPE
  end

  factory :client_not_owned, parent: :client do
    name "Not owned client"
    created_from ANOTHER_USER_URI
  end


  factory :scope do
    uri SCOPE_URI
    name "entidades"
  end

  factory :scope_entidades_read, parent: :scope do
    name "entidades/read"
    values ["entidades/index", "entidades/show"]
  end

  factory :scope_entidades_all, parent: :scope do
    name "entidades"
    values ["entidades/read", "entidades/create", "entidades/update", "entidades/destroy"]
  end

  factory :scope_pastas_read, parent: :scope do
    name "pastas/read"
    values ["pastas/index", "pastas/show"]
  end

  factory :scope_pastas_all, parent: :scope do
    name "pastas"
    values ["pastas/create", "pastas/update", "pastas/destroy", "pastas/read"]
  end

  factory :scope_read, parent: :scope do
    name "read"
    values ["entidades/read", "pastas/read"]
  end

  factory :scope_all, parent: :scope do
    name "all"
    values ["entidades", "pastas"]
  end

end


