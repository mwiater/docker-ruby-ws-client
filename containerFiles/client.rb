require 'bundler/setup'
require 'faye/websocket'
require 'eventmachine'
require 'permessage_deflate'
require 'json'
require 'awesome_print'

@nodeID = ENV['NODE_ID']
@url    = "ws://mjw-vm-ruby"
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
    ws.send(formatMessage(Time.now, "nodeConnection", @nodeID));

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
    begin
      message = JSON.parse(message.data, :symbolize_names => :true)
      
      case message[:type]
      when "heartbeat"
        puts "⇄ INCOMING ⇄".white
        puts "Valid Server Message received:".green
        puts "  Time:      #{message[:time]}".green
        puts "  Type:      #{message[:type]}".green
        puts "  Client ID: #{message[:clientID]}".green
        puts "  Data:      #{message[:data]}".green
        puts "✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭ ✭"
        puts ""
      else
        puts "Unknown message type: #{message[:type]}".red
        puts "  Data: #{message[:data]}".red
        puts "-----"
        puts ""
      end

    rescue Exception => e
      puts "Invalid message format, could not parse: #{message}"
      ap e
    end
  end
}