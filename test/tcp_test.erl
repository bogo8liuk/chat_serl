-module(tcp_test).

-include_lib("eunit/include/eunit.hrl").

multiple_tcp_client_should_connect_test() ->
    {ListenRes, LS} = tcp:listen(5678),
    ?assertEqual(ok, ListenRes),
    spawn(?MODULE, fun () -> tcp:accept(LS) end),
    Host = "localhost",
    {ConnectRes, Socket} = gen_tcp:connect(Host, 5678, [binary, {packet, 0}]),
    ?assertEqual(ok, ConnectRes).
    %ok = gen_tcp:send(Socket, "Some Data"),
    %ok = gen_tcp:close(Socket).
