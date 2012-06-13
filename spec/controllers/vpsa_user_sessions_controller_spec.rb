require 'spec_helper'

describe VpsaUserSessionsController do

  describe "POST " do

    def url_redirect
      'http://localhost:3000'
    end

    def do_create
      post 'create', {:cnpj => "70487814000188"}, {:back => url_redirect}
    end

    it "retorna um redirect" do
     do_create
     response.should be_redirect
    end
    it "redireciona para a url definida na sessao (:back)" do
     do_create
     response.should redirect_to(url_redirect)
    end
  end

end
