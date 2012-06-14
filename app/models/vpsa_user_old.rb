class VpsaUserOld
    
  def self.credenciais_validas? login, senha
    response = client.request(:int, :efetuar_login) do
      http.auth.ssl.verify_mode = :none
      soap.namespaces["xmlns:int"] = "http://interfaces.cadastro.service.vpsa.com.br/"
      soap.body = {:login => login, :senha => senha}
    end
    response.to_hash[:recuperar_bases_por_documento_response][:return].first[:schema]
  end

  private

  def self.client
    @@client ||= Savon::Client.new do
      wsdl.endpoint = VpsaUrls.env['usuario_endpoint']
      wsdl.namespace = "http://cadastro.service.vpsa.com.br/"
    end
  end
  
end
