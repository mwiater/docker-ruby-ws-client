require 'bundler/setup'
require 'faye/websocket'
require 'eventmachine'
require 'permessage_deflate'
require 'json'
require 'awesome_print'

@nodeID = ENV['NODE_ID']
@url    = "ws://mjw-u14-ruby"
@timer  = nil

def formatMessage(time, messageType, clientID, messageData = "")
  message            = {}
  message[:time]     = time
  message[:type]     = messageType
  message[:clientID] = clientID
  message[:data]     = messageData

  message.to_json.to_s
end

EM.run {
  ws = Faye::WebSocket::Client.new(@url, [],
    :extensions => [PermessageDeflate]
  )

  ws.onopen = lambda do |event|
    if @timer.nil?
      @timer = EventMachine::PeriodicTimer.new(5) do
        puts "Sending nodeHeartbeat...".green
        puts "-----"
        puts ""
        
        ws.send(formatMessage(Time.now, "nodeHeartbeat", @nodeID))
      end
    end

    p [:open, ws.headers]
  end

  ws.onclose = lambda do |close|
    p [:close, close.code, close.reason]
    EM.stop
  end

  ws.onerror = lambda do |error|
    p [:error, error.message]
  end

  ws.onmessage = lambda do |message|
    p [:message, message.data]
  end
}