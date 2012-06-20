module VpsaConfig
  
  def self.urls
    @@urls ||= YAML.load_file("#{Rails.root}/config/vpsa_urls.yml")
    @@urls[Rails.env]
  end
  
  def self.api
    @@api ||= YAML.load_file("#{Rails.root}/config/vpsa_api.yml")
    @@api[Rails.env]
  end
  
end
