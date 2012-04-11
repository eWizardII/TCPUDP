require 'rubygems'
require 'em-websocket'
require 'socket'
require 'eventmachine'
require 'em-http-request'
require 'juggernaut'

# Detect the Clients IP ADDR Orginally Sourced from CODERRR 
# http://coderrr.wordpress.com/2008/05/28/get-your-local-ip-address/

def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

# Gate Keeper

s = TCPSocket.new('caladbolg.princeton.edu',8189)
s.puts "ADD #{local_ip} 8190"
s.close_write
puts s.read
s.close

t = TCPSocket.new('balmung.princeton.edu',8189)
t.puts "ADD #{local_ip} 8191"
t.close_write
puts t.read
t.close

s = UDPSocket.new
s.bind("#{local_ip}",8190)

t = UDPSocket.new
t.bind("#{local_ip}",8191)

while true
	texts,senders = s.recvfrom(50)
	textt,sendert = t.recvfrom(50)
	Juggernaut.publish("carmonair","#{texts}")
	Juggernaut.publish("vanderfly","#{textt}")
end