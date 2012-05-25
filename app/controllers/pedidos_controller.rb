class PedidosController < ApplicationController
  before_filter :oauth_authorized
    
  def index    
    render :json => HTTParty.get('https://www.vpsa.com.br/estoque/rest/externo/showroom/' + params[:id_entidade] + 'pedidos')
  end

  def show
    render :json => HTTParty.get('https://www.vpsa.com.br/estoque/rest/externo/showroom/' + params[:id_entidade] + 'pedidos/' << params[:id].to_s)
  end

end
