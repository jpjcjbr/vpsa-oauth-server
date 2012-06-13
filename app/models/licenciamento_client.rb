class LicenciamentoClient
    
  def self.get_base cnpj
    response = client.request(:int, :recuperar_bases_por_documento) do
      http.auth.ssl.verify_mode = :none
      soap.namespaces["xmlns:int"] = "http://interfaces.base.service.vpsa.com.br/"
      soap.body = {:doc => cnpj}
    end
    response.to_hash[:recuperar_bases_por_documento_response][:return].first[:schema]
  end

  private

  def self.client
    @@client ||= Savon::Client.new do
      wsdl.endpoint = "https://www.vpsa.com.br/licenciamento/service/serviceBase"
      wsdl.namespace = "http://base.service.vpsa.com.br/"
    end
  end
  
end
