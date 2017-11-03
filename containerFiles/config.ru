# Run using your favourite server:
#
# puma config.ru -p 9292

require 'bundler/setup'
require File.expand_path('../app', __FILE__)

Faye::WebSocket.load_adapter('puma')

run App