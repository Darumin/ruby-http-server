require "test/unit"
require "socket"

include Socket::Constants

class TestRubby < Test::Unit::TestCase
    def test_this_test
        client = Socket.new(AF_INET, SOCK_STREAM, 0)
        addr = Socket.pack_sockaddr_in(6789, "127.0.0.1")
        client.connect(addr)
        client.send "GET someword", 0
        assert(line == "thedescription")
    end
end
