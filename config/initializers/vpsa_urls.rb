module VpsaUrls
  
  def self.env
    @@settings ||= YAML.load_file("#{Rails.root}/config/vpsa_urls.yml")
    @@settings[Rails.env]
  end
  
end
