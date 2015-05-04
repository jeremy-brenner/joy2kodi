
require 'json'
require 'net/http'

class Kodi
  def initialize(settings)
    @user = settings['user']
    @pass = settings['pass']
    @host = settings['host']
    @port = settings['port']
    @mq = {}
    @repeat_rate = 0.25
  end
  def rpc_url
    "http://#{@host}:#{@port}/jsonrpc"
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
    req = Net::HTTP::Post.new(uri)
    req.body = command(method).to_json
    req.basic_auth @user, @pass
    req.content_type = 'application/json'
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    JSON.parse(res.body)
  end
  def exec(method)
    @mq[method] ||= { run: true, last: 0 }
    if @mq[method][:run] != true and ( Time.now - @mq[method][:last] ) > @repeat_rate
      @mq[method][:run] = true
    end
    run_queue
  end

  def run_queue
    @mq.keys.each do |key| 
      if @mq[key][:run] == true
        post key
        @mq[key] = { run: false, last: Time.now }
      end
    end
  end
end