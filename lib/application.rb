class RackAuthSso

  def initialize(app)
    #@log = "Entering Rack::Auth::Kerberos"
    @app = app
  end

  ##############################################################
  # call -- RACK routine for processing authentication
  #
  # Parameters --
  #     env - Environmental variables passed to the Rails::Rack
  #
  # Returns -- None
  #
  ##############################################################
  def call(env)

    ## check for existance of Cookie
    if /(MSIE|Internet Explorer)/ =~ env['HTTP_USER_AGENT']
      ## USER_AGENT is a IE-based browser
      require 'net/ntlm'
      require 'kconv'

      ## See if it is possible to use NTLM to autenticate
      if env['HTTP_AUTHORIZATION'].blank?
        return [401, {'WWW-Authenticate' => "NTLM"}, []]
      end
      if /^(NTLM|Negotiate) (.+)/ =~ env["HTTP_AUTHORIZATION"]

        message = Net::NTLM::Message.decode64($2)

        if message.type == 1
          type2 = Net::NTLM::Message::Type2.new
          return [401, {"WWW-Authenticate" => "NTLM " + type2.encode64}, []]
        end

        if message.type == 3
          user = Net::NTLM::decode_utf16le(message.user)
          require "base64"
          env['AUTH_USER'] = user
          env['AUTH_USER_AUTH'] = Base64.encode64(user)
          env['AUTH_DATETIME'] = Time.now.utc
        else
          return [401, {}, ["You are not authorized to see this page"]]
        end
      end
      @app.call(env)
    else
      ##############################################################
      # USER_AGENT is a NON-IE-based browser (Firefox, Safari, etc.)
      #
      # Process these agents using session based cookies which
      # are authenticated via kerberos. Once the agent quits their
      # browser session or clears their cookies during an open
      # browser session, the agent must re-authenticate via their
      # kerberos username and password. Authenticated user agents
      # have the correct AUTH_USER (network login name) inserted
      # as an environmental variable prior to their being sent on
      # any followon Rails application. The login is completely
      # customizable and does not use the browser's login capability.
      #
      ##############################################################

      auth_user = get_cookie(env,'AUTH_USER')
      auth_user_auth = get_cookie(env,'AUTH_USER_AUTH')
      require "base64"
      auth_user_auth_v = (auth_user_auth.nil?) ? nil : Base64.decode64(auth_user_auth)

      if auth_user.nil? || auth_user_auth.nil? || auth_user != auth_user_auth_v
        ## Not yet Authenticated
        lgin = "<form action=\"#{env['rack.url_scheme']}://"
        lgin += "#{env['SERVER_NAME']}#{env['REQUEST_URI']}\" method=\"post\">\n"
        lgin += "Username:<br><input type=\"text\" name=\"kun\" id=\"kun\" />\n<p>"
        lgin += "Password:<br><input type=\"password\" name=\"kpw\" id=\"kpw\" />\n<p>"
        lgin += "<input type=\"submit\" value=\"Login\"/>\n</form>\n</body>\n</html>\n"

        if env['REQUEST_METHOD'] == 'POST'
          ## Authenticate un/pw sent via POST
          require 'rkerberos'
          kerberos = Kerberos::Krb5.new
          realm ||= kerberos.get_default_realm
          user = env['rack.request.form_hash']['kun']
          user_with_realm = user.dup
          user_with_realm += "@#{realm}" unless user.include?('@')
          password = env['rack.request.form_hash']['kpw']

          begin
            kerberos.get_init_creds_password(user_with_realm, password)
            rescue Kerberos::Krb5::Exception => err
              ## Authentication was UNSUCCESSFUL - username/password typo
              env.delete('AUTH_USER')
              env['AUTH_MSG'] = "Error attempting to validate userid and password"
              env['AUTH_FAIL'] = err.message

            rescue => err
              env.delete('AUTH_USER')
              env['AUTH_FAIL'] = "Unexpected failure during Kerberos authentication"

            else
              ## Authentication was Successful - Update AUTH_USER
              env.delete('AUTH_FAIL')
              env['AUTH_USER'] = user
              env['AUTH_USER_AUTH'] = Base64.encode64(user)
              env['AUTH_DATETIME'] = Time.now.utc

            ensure
              ## Clean up any outstanding calls from above operations
              kerberos.close

          end

          if env.has_key?('AUTH_USER')
            ## Authentication was successful, set cookies and pass on to Rails
            ## SET COOKIES
            status,headers,response = @app.call(clean_params(env))
            Rack::Utils.set_cookie_header!(headers, "AUTH_USER",
                                                    {:value => env['AUTH_USER'], :path => "/"})
            Rack::Utils.set_cookie_header!(headers, "AUTH_USER_AUTH",
                                                    {:value => env['AUTH_USER_AUTH'], :path => "/"})
            [status,headers,response]
          else
            ## Authentication was UNsuccessful, flash login and indicate error
            status,headers,ignore = @app.call(env)
            response = "<!DOCTYPE html>\n<!-- #{env['AUTH_FAIL']} -->\n<!-- #{env.inspect} -->\n"
            response << "<html>\n<body>\n<font color=#ff0000>#{env['AUTH_MSG']}</font><p>\n"
            response << lgin
            response = [response]
            headers["Content-Length"] = response.size.to_s
            [status,headers,response]
          end
        else
          ## Show RACK login
          status,headers,ignore = @app.call(env)
          response = "<!DOCTYPE html>\n<!-- #{env['AUTH_FAIL']} -->\n<!-- #{env.inspect} -->\n"
          response << lgin
          response = [response]
          headers["Content-Length"] = response.size.to_s
          [status,headers,response]
        end
      else
        ## Assume user is authenticated and pass correct AUTH_USER to Rails application
        env['AUTH_USER'] = auth_user
        env['AUTH_USER_AUTH'] = auth_user_auth
        env['AUTH_DATETIME'] = Time.now.utc
        @app.call(env)
      end
    end
  end

  ##############################################################
  # getCookie -- Custom (native to Core-Rack) routine for parsing cookies
  #
  # Parameters --
  #     myEnv - Environmental variables passed to the Rails::Rack
  #     key   - Desired cookie name for which a value is requested
  #
  # Returns -- The value of the cookie, or nil (if no cookie exists)
  #
  ##############################################################
  def get_cookie(my_env,key)
    cookies = Hash.new
    if my_env.has_key?('rack.request.cookie_hash')
      if my_env['rack.request.cookie_hash'].has_key?(key)
        return(my_env['rack.request.cookie_hash'][key])
      else
        return(nil)
      end
    end
  end

  ##############################################################
  # cleanParams -- Remove potential login password from params
  #
  # Parameters --
  #     myEnv - Environmental variables passed to the Rails::Rack
  #
  # Returns -- Cleaned env variable to pass back to the user agent
  #
  ##############################################################
  def clean_params(my_env)
    my_env['rack.request.form_hash'].delete('kpw')
    my_array = Array.new
    r = /(\&?kpw\=[^\&]+)/  ## or /kpw\=([^\&]+)/ to just replace the password
    my_env['rack.request.form_vars'].gsub!(r) { |m| m.gsub!($1,'')}
    my_env
  end
end