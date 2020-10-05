require 'socket'

class Server
    def initialize
        # bind socket and start server
        @socket = Socket.new(:INET, :STREAM, 0)
        @socket.bind(Addrinfo.tcp("127.0.0.1", 6789))

        @definitions = {
            "someword" => "thedescription"
        }

        puts "✔️ Server successfully started."
        p @socket.local_address
    end

    def listen
        # listen for connections
        @socket.listen(1)
        puts "Listening...\n"

        # part out socket.accept
        conn, conn_addr = @socket.accept
        puts "✔️ Client connected successfully.\n"
        p conn_addr

        # send and receive messages
        dictionary_protocol(conn)
    end

    def dictionary_protocol(connection)
        connection.send "You connected to the dictionary protocol.\r\n", 0

        loop do
            data = connection.recvfrom(25)[0].chomp.split(/ /, 3)
            command, key, setdesc = data[0], data[1], data[2]

            sleep 1

            case
            when command.eql?("SET")
                if @definitions.has_key?(key)
                    connection.send "Key already set.\r\n", 0
                else
                    @definitions[key] = setdesc
                    connection.send "Key is set.\r\n", 0
                end     
            when command.eql?("GET")
                if key == nil
                    connection.send "No such word exists.\r\n", 0
                else
                    desc = @definitions[key]
                    connection.send "#{desc}\r\n", 0
                end
            when command.eql?("CLEAR") 
                @definitions.clear
            when command.eql?("END") 
                connection.send "Goodbye!\r\n", 0 
                break 
            else
                connection.send "Invalid command.\r\n", 0
            end
        end

    end

    def close
        # when finished, call this
        puts "Now closing the socket."
        @socket.close
    end
        
end

serve = Server.new()
serve.listen
serve.close