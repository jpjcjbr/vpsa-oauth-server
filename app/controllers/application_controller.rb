class ApplicationController < ActionController::Base
  include Lelylan::Rescue::Helpers

  protect_from_forgery

  before_filter :authenticate
  helper_method :current_user
  helper_method :admin_does_not_exist

  rescue_from BSON::InvalidObjectId,        with: :bson_invalid_object_id
  rescue_from JSON::ParserError,            with: :json_parse_error
  rescue_from Mongoid::Errors::InvalidType, with: :mongoid_errors_invalid_type

  protected

    def json_body
      @body = HashWithIndifferentAccess.new(JSON.parse(request.body.read.to_s))
    end

    def authenticate      
      if api_request
        # oauth_authorized   # uncomment to make all json API protected
      else
        session_auth
      end
    end

    def authenticate_vpsa_user
      vpsa_user_session_auth
    end

    def api_request
      json?
    end

    def json?
      request.format == "application/json"
    end

    def session_auth
      @current_user ||= User.criteria.id(session[:user_id]).first if session[:user_id]
      unless current_user
        session[:back] = request.url 
        redirect_to(log_in_path) and return false
      end
      return @current_user
    end

    def vpsa_user_session_auth
      unless current_vpsa_user_id
        session[:back] = request.url
        redirect_to(vpsa_log_in_path) and return false
      end
      return true
    end
    
    def current_user
      @current_user
    end
    
    def current_vpsa_user_uri
      current_vpsa_user_base.to_s + "/" + current_vpsa_user_id.to_s if current_vpsa_user_base && current_vpsa_user_id
    end
    
    def current_vpsa_user_id
      session[:vpsa_user_id]
    end
    
    def current_vpsa_user_base
      session[:vpsa_user_base]
    end

    def oauth_authorized
      action = params[:controller] + "/" + params[:action]
      action = action[4, action.length] if action.start_with? 'api/'
      
      normalize_token
      
      @token = OauthToken.where(token: params[:token]).all_in(scope: [action]).first
      if @token.nil? or @token.blocked?
        render text: "Unauthorized access.", status: 401
        return false
      else
        parse_vpsa_user_uri
        access = OauthAccess.where(client_uri: @token.client_uri , resource_owner_uri: @token.resource_owner_uri).first
        access.accessed!
      end
    end

    def normalize_token
      # Token in the body
      if (@body and @body[:token] and json_body)
        params[:token] = @body[:token]
      end
      
      # Token in the header
      if request.env["Authorization"]
        params[:token] = request.env["Authorization"].split(" ").last
      end
    end
    
    def parse_vpsa_user_uri
      @vpsa_user_base = @token.resource_owner_uri.split('/')[0]
      @vpsa_user_id = @token.resource_owner_uri.split('/')[1]
    end
 
    def url_formatada_vpsa url_key
      args = {
        :url => VpsaConfig.urls[url_key], 
        :base => @vpsa_user_base, 
        :usuario => @vpsa_user_id,
        :entidades => params[:entidades], :inicio => params[:inicio], :quantidade => params[:quantidade],
        :quantidade_maxima => VpsaConfig.api['quantidade_maxima']
      }
      UrlVpsa.new(args).formatada
    end
    
    def admin_does_not_exist
      User.where(admin: true).first.nil?
    end
end
