class Api::EntidadesController < ApplicationController

  before_filter :oauth_authorized
    
  def index
    render :json => HTTParty.get(url_com_base(VpsaUrls.env['entidades_url'])), :callback => params[:callback] 
  end

  def show
    render :json => HTTParty.get(url_com_base(VpsaUrls.env['entidades_url']) << params[:id].to_s), :callback => params[:callback] 
  end

end
