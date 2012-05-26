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
      print '<<<<<<<<<<<<< format' << request.format
      
      if api_request
        print '<<<<<<<< api request'
        # oauth_authorized   # uncomment to make all json API protected
      else
        session_auth
      end
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
        print '<<<<<<<<<<<<<<<<<<<<<<< redirecionou a bagaca'
        redirect_to(log_in_path) and return false
      end
      return @current_user
    end

    def current_user
      @current_user
    end

    def oauth_authorized
      print '<<<<<<<<<<<<<<<<<<<<<<<<< oauth_authorized'
      action = params[:controller] + "/" + params[:action]
      print '<<<<<<<<<<<<<<<<<<<<<<<<< action ' << action
      normalize_token
      
      print '<<<<<<<<<<<<<<<<<<<<<<<<< token ' << params[:token]
      @token = OauthToken.where(token: params[:token]).all_in(scope: [action]).first
      
      print '<<<<<<<<<<<<<<<<<<<<<<<<< ' << @token.inspect
      
      if @token.nil? or @token.blocked?
        render text: "Unauthorized access.", status: 401
        return false
      else 
        access = OauthAccess.where(client_uri: @token.client_uri , resource_owner_uri: @token.resource_owner_uri).first
        access.accessed!
      end
    end

    def normalize_token
      
      print '<<<<<<<<<<<<<<<<<<<<<< normalize\n'
      # Token in the body
      if (@body and @body[:token] and json_body)
        print '<<<<<<<<<<<<<<<<<<<<<< json esta no body'
        params[:token] = @body[:token]
      end
      
      print '<<<<<<<<<<<<<<<<<<<<<< depois da verificacao do body'
      # Token in the header
      if request.env["Authorization"]
        print '<<<<<<<<<<<<<<<<<<<<<< json esta no authorization\n'
        params[:token] = request.env["Authorization"].split(" ").last
      end
      
      print '<<<<<<<<<<<<<<<<<<<<<< normalize_token'
    end

    def admin_does_not_exist
      User.where(admin: true).first.nil?
    end

end
