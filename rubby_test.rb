require "test/unit"
require "socket"

include Socket::Constants

class TestRubby < Test::Unit::TestCase
    def setup
        @client = Socket.new(AF_INET, SOCK_STREAM, 0)
        @addr = Socket.pack_sockaddr_in(6789, "127.0.0.1")
        @client.connect(@addr)
    end

    def test_answer
        @client.send "GET someword", 0
        line = @client.recvfrom(128)[0].chomp
        assert_equal(line, "ANSWER somedefinition")
        @client.send "RUBBY", 0
        line = @client.recvfrom(128)[0].chomp
        assert_equal(line, "Invalid command")
    end

    # def test_invalid_command
    #     @client.send "RUBBY", 0
    #     line = @client.recvfrom(128)[0].chomp
    #     assert_equal(line, "Invalid command")
    # end

    def teardown
        @client.send "END", 0
        @client.close
    end
end
