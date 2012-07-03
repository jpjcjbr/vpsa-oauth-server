class Api::ContasReceberController < ApplicationController

  before_filter :oauth_authorized
    
  def index
    render :json => HTTParty.get(url_formatada_vpsa('contas_receber_url')), :callback => params[:callback] 
  end

  def show
    render :json => HTTParty.get(url_formatada_vpsa('contas_receber_url') << params[:id].to_s), :callback => params[:callback] 
  end

end
