class ProdutosController < ApplicationController
  before_filter :oauth_authorized
    
  def index    
    render :json => HTTParty.get('https://www.vpsa.com.br/estoque/rest/externo/showroom/' + params[:id_entidade] + 'produtos')
  end

  def show
    render :json => HTTParty.get('https://www.vpsa.com.br/estoque/rest/externo/showroom/' + params[:id_entidade] + 'produtos/' << params[:id].to_s)
  end

end
