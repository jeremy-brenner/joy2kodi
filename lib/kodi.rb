
require 'json'
require 'net/http'
require 'pp'
class Kodi
  def initialize(settings)
    @user = settings['user']
    @pass = settings['pass']
    @host = settings['host']
    @port = settings['port']
    @mq = {}
    @repeat_rate = 0.25
    @alive = true
  end

  def rpc_url
    "http://#{@host}:#{@port}/jsonrpc"
  end

  def running
    # Only send a ping if we have a reason to believe it is down.
    @alive || post('JSONRPC.Ping')['result'] == 'pong'
  end

  def wait_for_it
    while not running
      print "Waiting for Kodi...\n"
      sleep 2
    end
    print "Kodi is alive!\n"
    true
  end

  def command(method)
    {
      "jsonrpc" => "2.0",
      "method" => method,
      "id" => 1
    }
  end

  def post(method)
    uri = URI rpc_url
    req = Net::HTTP::Post.new(uri.path)
    req.body = command(method).to_json
    req.basic_auth @user, @pass
    req.content_type = 'application/json'
    begin
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      @alive = true
      JSON.parse(res.body)
    rescue
      @alive = false
      { error: 'failed' }
    end
  end

  def elapsed(method)
    Time.now - @mq[method]
  end

  def exec(method)
    if not @mq.has_key? method or elapsed(method) > @repeat_rate
      print "Calling #{method}\n"
      post method
      @mq[method] =  Time.now 
    end
  end

end