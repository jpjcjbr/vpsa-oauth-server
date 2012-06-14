class BaseLicenciamento
   
  extend Savon::Model
  
  endpoint VpsaUrls.env['licenciamento_endpoint']
  namespace "http://base.service.vpsa.com.br/"

  def self.find cnpj
    response = client.request(:int, :recuperar_bases_por_documento) do
      http.auth.ssl.verify_mode = :none
      soap.namespaces["xmlns:int"] = "http://interfaces.base.service.vpsa.com.br/"
      soap.body = {:doc => cnpj}
    end
    returned_data = response.to_hash[:recuperar_bases_por_documento_response][:return]
    returned_data.first[:schema] if returned_data
  end
  
end