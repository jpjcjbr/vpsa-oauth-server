require 'spec_helper'

describe UsuarioVpsa do

  describe "find" do
    
    it "retorna o usuario para login e senha validos" do
      login = "admin"
      senha = "2010"
      base = "showroom"
      response_body = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><schemaxmlns="http://schema.vpsa.com.br">v___SCV___showroom___SP___e___SCV___showroom</schema><dataRecebimentoxmlns="http://dataRecebimento.vpsa.com.br">1339677307965</dataRecebimento></soap:Header><soap:Body><ns2:efetuarLoginResponsexmlns:ns2="http://interfaces.cadastro.service.vpsa.com.br/"><return><retornoxsi:type="ns2:usuarioVo"xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><email>suportetecnico@vpsa.com.br</email><id>1</id><idTerceiro>2</idTerceiro><login>admin</login><nome>ADMINISTRADOR</nome><senha>4izUYcBorqXf8cNGIhSIDXaz45w=</senha></retorno></return></ns2:efetuarLoginResponse></soap:Body></soap:Envelope>'
      savon.expects(:efetuar_login).with(:login => login, :senha => senha).returns(:code => 200, :headers => {}, :body => response_body)
      UsuarioVpsa.find(login, senha, base)[:id].should == "1"
    end
    
    it "retorn nil para login e senha invalidos" do
      login = "admin"
      senha = "20101"
      base = "showroom"
      response_body = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><schemaxmlns="http://schema.vpsa.com.br">v___SCV___showroom___SP___e___SCV___showroom</schema><dataRecebimentoxmlns="http://dataRecebimento.vpsa.com.br">1339677307965</dataRecebimento></soap:Header><soap:Body><ns2:efetuarLoginResponsexmlns:ns2="http://interfaces.cadastro.service.vpsa.com.br/"><return><erros><chave>Usuario invalido, tente novamente.</chave></erros></return></ns2:efetuarLoginResponse></soap:Body></soap:Envelope>'
      savon.expects(:efetuar_login).with(:login => login, :senha => senha).returns(:code => 200, :headers => {}, :body => response_body)
      UsuarioVpsa.find(login, senha, base).should be_nil
    end
    
  end

end
