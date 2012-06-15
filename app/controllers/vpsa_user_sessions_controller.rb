class VpsaUserSessionsController < ApplicationController

  skip_before_filter :authenticate

  def new
  end

  def create
    base = BaseLicenciamento.find(params[:cnpj])
    unless base
      flash.now.alert = "CNPJ nao encontrado"
      render "new" and return false
    end
    session[:vpsa_user_base] = base
    
    vpsa_user = UsuarioVpsa.find(params[:login],params[:password],base)
    unless vpsa_user
      flash.now.alert = "Usuario invalido"
      render "new" and return false
    end
    session[:vpsa_user_id] = vpsa_user[:id]
    session[:back] ||= vpsa_log_in_path
    redirect_to session[:back]
    session[:back] = nil
  end

  def destroy
    session[:vpsa_user_base] = nil
    session[:vpsa_user_id] = nil
    redirect_to root_url
  end

end
