require 'socket'


# start socket
socket = Socket.new(:INET, :STREAM, 0)
socket.bind(Addrinfo.tcp("127.0.0.1", 6789))
puts "Socket service started."
p socket.local_address

# listen for connections
socket.listen(1)
puts "Now listening...\n"

# part out socket.accept
conn, conn_addr = socket.accept
puts "Connected to PuTTY.\n"
p conn_addr

# send and receive messages
loop do
    data = conn.recvfrom(25)[0].chomp
    if data == '' then break end
    
    # to client, and back to server.
    conn.send "you sent me this --> '#{data}'\n", 0
    puts "max_bytes(25) --> '#{data}'"
    sleep 1
end

# when finished, close the socket
puts "Now closing the socket."
socket.close