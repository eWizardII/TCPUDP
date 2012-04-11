require 'socket'

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

s = TCPSocket.new('balmung.princeton.edu',8189)
s.puts "ADD #{local_ip} 8191"
s.close_write
puts s.read
s.close


# Gate Listener

s = UDPSocket.new
s.bind("#{local_ip}",8191)
while true
	text,sender = s.recvfrom(50)
	puts text
end

