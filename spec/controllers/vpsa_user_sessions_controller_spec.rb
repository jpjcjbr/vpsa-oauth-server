require 'spec_helper'

describe VpsaUserSessionsController do

  describe "POST " do

    def url_redirect
      'http://localhost:3000'
    end
    
    def do_create
      post 'create', {:cnpj => "70487814000188"}, {:back => url_redirect}
    end

    before(:each) do
      BaseLicenciamento.stub!(:find).and_return("base_teste")
      UsuarioVpsa.stub!(:find).and_return({:id => "123"})
    end

    it "retorna um redirect" do
     do_create
     response.should be_redirect
    end
    it "redireciona para a url definida na sessao (:back)" do
     do_create
     response.should redirect_to(url_redirect)
    end
    it "avisa quando o CNPJ informado nao e encontrado no Licenciamento" do
     BaseLicenciamento.stub!(:find).and_return(nil)
     do_create
     response.should render_template("new")
    end
    it "guarda a base na sessao do usuario" do
     base = "base_12"
     BaseLicenciamento.stub!(:find).and_return(base)
     do_create
     session[:vpsa_user_base].should be(base)
    end
    it "avisa quando o login e invalido" do
      UsuarioVpsa.stub!(:find).and_return(nil)
     do_create
     response.should render_template("new")
    end
    it "guarda o id do usuario na sessao" do
     id = "9983723"
     UsuarioVpsa.stub!(:find).and_return({:id => id})
     do_create
     session[:vpsa_user_id].should be(id)
    end
  end

end
