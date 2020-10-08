require "socket"
require "singleton"

class RubyServer
    include Singleton
    attr_reader :dictionary
    attr_writer :dictionary

    def initialize
        @socket = Socket.new(:INET, :STREAM, 0)
        @socket.bind(Addrinfo.tcp("127.0.0.1", 6789))

        @dictionary = dictionary
        p @socket.local_address
    end

    def listen
        @socket.listen(1)
        puts "✔️ Server successfully started."
        puts "Listening for incoming connections...\n"
        
        # TODO: Implement a backlog.
        @client, client_addr = @socket.accept
        puts "✔️ Client connected successfully.\n"

        p client_addr 
    end

    def dictionary_protocol
        if @dictionary == nil
            return
        end

        loop do
            data = @client.recvfrom(128)[0].chomp.split(/ /, 3)
            command, key, setdesc = *data

            sleep 1

            case
            when command.eql?("SET")
                @dictionary[key] = setdesc
                @client.send "Key `#{key}` has been set to `#{setdesc}`.\r\n", 0   
            when command.eql?("GET")
                if key == nil
                    @client.send "No such word exists.\r\n", 0
                else
                    desc = @dictionary[key]
                    @client.send "ANSWER #{desc}\r\n", 0
                end
            when command.eql?("CLEAR") 
                @dictionary.clear
            when command.eql?("END")
                break 
            else
                @client.send "Invalid command\r\n", 0
            end
        end

    end

    def close
        puts "Successfully closed server."
        @socket.close
    end
end

rubby = RubyServer.instance
rubby.dictionary = {"someword" => "somedefinition", "anotherword" => "anotherdefinition"}
rubby.listen
rubby.dictionary_protocol
rubby.close


