require 'spec_helper'

describe VpsaUserSessionsController do

  describe "POST " do

    def url_redirect
      'http://localhost:3000'
    end

    def do_create_default
      LicenciamentoClient.stub!(:get_base).and_return("base_teste")
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
     LicenciamentoClient.stub!(:get_base).and_return(nil)
     do_create
     response.should render_template("new")
    end
    it "guarda a base na sessao do usuario" do
     base = "base_12"
     LicenciamentoClient.stub!(:get_base).and_return(base)
     do_create
     session[:vpsa_user_base].should be(base)
    end
  end

end
