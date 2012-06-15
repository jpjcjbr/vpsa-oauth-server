class ProdutosController < ApplicationController

  before_filter :oauth_authorized
    
  def index    
    render :json => HTTParty.get('https://www.vpsa.com.br/estoque/rest/externo/'+session[:vpsa_user_base]+'/' + params[:id_entidade] + 'produtos'), :callback => params[:callback] 
  end

  def show
    render :json => HTTParty.get('https://www.vpsa.com.br/estoque/rest/externo/'+session[:vpsa_user_base]+'/' + params[:id_entidade] + 'produtos/' << params[:id].to_s), :callback => params[:callback] 
  end

end
