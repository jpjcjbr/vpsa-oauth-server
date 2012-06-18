# TODO: define a yml file for configurations
module SettingsHelper

  # general
  HOST = "http://www.google.com.br"
  ANOTHER_HOST = "http://www.gmail.com.br"

  # resources
  BASE                = "showroom"
  VPSA_USER_ID        = "123"
  USER_URI            = BASE + "/" + VPSA_USER_ID
  ANOTHER_VPSA_USER_ID= "456"
  ANOTHER_USER_URI    = BASE + "/" + ANOTHER_VPSA_USER_ID
  ADMIN_URI           = HOST + "/users/admin"
  CLIENT_URI          = HOST + "/users/alice/client/lelylan"
  ANOTHER_CLIENT_URI  = HOST + "/users/alice/client/riflect"
  REDIRECT_URI        = HOST + "/app/callback"

  # scopes
  SCOPE_URI   = HOST + "/scopes/entidades"
  ALL_SCOPE   = ["entidades/index", "entidades/show", "entidades/create", "entidades/update", "entidades/destroy"]
  READ_SCOPE  = ["entidades/index", "entidades/show"]


  # urls validator
  VALID_URIS    = [ 'http://example.com',  'http://www.example.com',
                    'https://example.com', 'https://www.example.com',
                    'http://example.host', 'https://example.host' ]
  INVALID_URIS  = [ 'ftp://godaddy.com',   'www.godaddy.com', 'godaddy.com', 'example' ]

end
