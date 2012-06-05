require 'net/ntlm'
require 'kconv'

class SampleAuth
  def initialize(app)
    @app = app
  end

  def call(env)

    #status, headers, body = @app.call(env)
    headers = {}

    if env['HTTP_AUTHORIZATION'].blank?
      headers['WWW-Authenticate'] = "NTLM"
      return [401, headers, []]
    end

    #if /^(NTLM|Negotiate) (.+)/ =~ env["HTTP_AUTHORIZATION"]
    #  message = Net::NTLM::Message.decode64($2)
    #
    #  if message.type == 1
    #    type2 = Net::NTLM::Message::Type2.new
    #    headers['WWW-Authenticate'] = "NTLM #{type2.encode64}"
    #    return [401, headers, []]
    #  end
    #
    #  if message.type == 3
    #    user = Net::NTLM::decode_utf16le(message.user)
    #    require "base64"
    #    env['AUTH_USER'] = user
    #    env['AUTH_USER_AUTH'] = Base64.encode64(user)
    #    env['AUTH_DATETIME'] = Time.now.utc
    #  else
    #    return [401, {}, ["You are not authorized to see this page"]]
    #  end
    #end
    @app.call(env)
  end
end
