class LoggingUtils
  def LoggingUtils.get_ip(env)
        if addr = env['HTTP_X_FORWARDED_FOR']
           (addr.split(',').grep(/\d\./).first || env['REMOTE_ADDR']).to_s.strip
        else
            env['REMOTE_ADDR']
        end
  end
end