class VpsaUserSessionsController < ApplicationController

  skip_before_filter :authenticate

  def new
  end

  def create
    # TODO: logar no VPSA
    base = LicenciamentoClient.get_base(params[:cnpj])
    unless base
      flash.now.alert = "CNPJ nao encontrado"
      render "new" and return false
    end
    session[:vpsa_user_base] = base
    session[:vpsa_user_id] = 1
    redirect_to session[:back]
    session[:back] = nil
  end

  def destroy
    session[:vpsa_user_id] = nil
    redirect_to root_url
  end

end
