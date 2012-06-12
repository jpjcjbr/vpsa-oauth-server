class EntidadesController < ApplicationController
  before_filter :oauth_authorized
    
  def index    
    render :json => HTTParty.get('https://www.vpsa.com.br/vpsa/rest/externo/showroom/entidades'), :callback => params[:callback] 
  end

  def show
    render :json => HTTParty.get('https://www.vpsa.com.br/vpsa/rest/externo/showroom/entidades/' << params[:id].to_s), :callback => params[:callback] 
  end

end
