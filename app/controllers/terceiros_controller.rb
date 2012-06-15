class TerceirosController < ApplicationController

  before_filter :oauth_authorized
    
  def index
    render :json => HTTParty.get('https://www.vpsa.com.br/vpsa/rest/externo/'+session[:vpsa_user_base]+'/terceiros'), :callback => params[:callback] 
  end

  def show
    render :json => HTTParty.get('https://www.vpsa.com.br/vpsa/rest/externo/'+session[:vpsa_user_base]+'/terceiros/' << params[:id].to_s), :callback => params[:callback] 
  end

end
