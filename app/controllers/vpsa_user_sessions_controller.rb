class VpsaUserSessionsController < ApplicationController

  skip_before_filter :authenticate

  def new
  end

  def create
    # TODO: logar no VPSA
    session[:vpsa_user_id] = 1
    session[:back] ||= user_path(user)
    redirect_to session[:back], notice: "Logged in!"
    session[:back] = nil
  end

  def destroy
    session[:vpsa_user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
