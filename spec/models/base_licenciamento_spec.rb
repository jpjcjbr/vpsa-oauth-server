require 'spec_helper'

describe BaseLicenciamento do

  describe "find" do
    
    it "busca a base da empresa atraves do CNPJ no licenciamento" do
      cnpj = "70487814000188"
      base_response = "vpsa_vpsa_251"
      response_body = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><dataRecebimento xmlns="http://dataRecebimento.vpsa.com.br">1339608836596</dataRecebimento></soap:Header><soap:Body><ns2:recuperarBasesPorDocumentoResponse xmlns:ns2="http://interfaces.base.service.vpsa.com.br/"><return><chave>v</chave><schema>'+base_response+'</schema></return><return><chave>e</chave><schema>vpsa_estoque_251</schema></return><return><chave>c</chave><schema>vpsa_compras_251</schema></return></ns2:recuperarBasesPorDocumentoResponse></soap:Body></soap:Envelope>'
      savon.expects(:recuperar_bases_por_documento).with(:doc => cnpj).returns(:code => 200, :headers => {}, :body => response_body)
      base = BaseLicenciamento.find(cnpj) 
      base.should eq(base_response)
    end
    it "retorn nil para base nao encontrada" do
      cnpj = "00000000"
      response_body = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><dataRecebimento xmlns="http://dataRecebimento.vpsa.com.br">1339684466876</dataRecebimento></soap:Header><soap:Body><ns2:recuperarBasesPorDocumentoResponse xmlns:ns2="http://interfaces.base.service.vpsa.com.br/"/></soap:Body></soap:Envelope>'
      savon.expects(:recuperar_bases_por_documento).with(:doc => cnpj).returns(:code => 200, :headers => {}, :body => response_body)
      base = BaseLicenciamento.find(cnpj) 
      base.should be_nil
    end
  end

end
