class TerceirosController < ApplicationController

    
  def index    
    render :json => HTTParty.get('https://www.vpsa.com.br/vpsa/rest/externo/showroom/terceiros')
  end

  def show
    render :json => HTTParty.get('https://www.vpsa.com.br/vpsa/rest/externo/showroom/terceiros/' << params[:id].to_s)
  end

end
