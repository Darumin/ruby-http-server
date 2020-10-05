require 'socket'

class Server
    def initialize
        # bind socket and start server
        @socket = Socket.new(:INET, :STREAM, 0)
        @socket.bind(Addrinfo.tcp("127.0.0.1", 6789))

        puts "Server successfully started."
        p @socket.local_address
    end

    def listen
        # listen for connections
        @socket.listen(1)
        puts "Now listening...\n"

        # part out socket.accept
        conn, conn_addr = @socket.accept
        puts "Connection made to...\n"
        p conn_addr

        # send and receive messages
        dictionary_protocol(conn)

        puts "Now closing the socket."
        @socket.close
    end

    def dictionary_protocol(connection)
        loop do
            data = connection.recvfrom(25)[0].chomp
            if data == '' then 
                break 
            end

            # from client, then back to server.
            connection.send "you sent me this --> '#{data}'\r\n", 0
            puts "max_bytes(25) --> '#{data}'"
            sleep 1
        end
    end
        
end

serve = Server.new()
serve.listen()
# when finished, close the socket
