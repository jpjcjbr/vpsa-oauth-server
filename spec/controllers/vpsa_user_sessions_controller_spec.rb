require 'spec_helper'
require 'mocha'

describe VpsaUserSessionsController do

  describe "POST " do

    def url_redirect
      'http://localhost:3000'
    end

    def do_create_default
      LicenciamentoClient.expects(:get_base).returns("base_teste")
      do_create
    end
    
    def do_create
      post 'create', {:cnpj => "70487814000188"}, {:back => url_redirect}
    end

    it "retorna um redirect" do
     do_create_default
     response.should be_redirect
    end
    it "redireciona para a url definida na sessao (:back)" do
     do_create_default
     response.should redirect_to(url_redirect)
    end
    it "avisa quando o CNPJ informado nao e encontrado no Licenciamento" do
     LicenciamentoClient.expects(:get_base).returns(nil)
     do_create
     response.should render_template("new")
    end
    it "guarda a base na sessao do usuario" do
     base = "base_123"
     LicenciamentoClient.expects(:get_base).returns(base)
     do_create
     session[:vpsa_user_base].should be(base)
    end
  end

end
