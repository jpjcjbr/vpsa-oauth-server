class UsuarioVpsa
    
  extend Savon::Model
  
  endpoint VpsaConfig.urls['usuario_endpoint']
  namespace "http://cadastro.service.vpsa.com.br/"

  def self.find(login, senha, base)
    response = client.request(:int, :efetuar_login) do
      http.auth.ssl.verify_mode = :none
      soap.namespaces["xmlns:int"] = "http://interfaces.cadastro.service.vpsa.com.br/"
      
      soap.header_attributes = { :xmlns => "http://schema.vpsa.com.br" }
      soap.header = {:schema =>  "v___SCV___" + base}
      soap.body = {:login => login, :senha => senha}
    end
    response.body[:efetuar_login_response][:return][:retorno]
  end
  
end
