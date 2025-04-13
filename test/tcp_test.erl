-module(tcp_test).

-include_lib("eunit/include/eunit.hrl").

single_tcp_client_should_connect_test() ->
    {ListenRes, LS} = tcp:listen(5678),
    ?assertEqual(ok, ListenRes),
    spawn(?MODULE, fun () -> tcp:accept(LS) end),
    Host = "localhost",
    {ConnectRes, Socket} = gen_tcp:connect(Host, 5678, [binary, {packet, 0}]),
    ?assertEqual(ok, ConnectRes).
    %ok = gen_tcp:send(Socket, "Some Data"),
    %ok = gen_tcp:close(Socket).

multiple_tcp_client_should_connect_test() ->
    {ListenRes, LS} = tcp:listen(5679),
    ?assertEqual(ok, ListenRes),
    spawn(?MODULE, fun () -> tcp:accept(LS) end),
    Host = "localhost",
    {ConnectRes1, Socket1} = gen_tcp:connect(Host, 5679, [binary, {packet, 0}]),
    {ConnectRes2, Socket2} = gen_tcp:connect(Host, 5679, [binary, {packet, 0}]),
    {ConnectRes3, Socket3} = gen_tcp:connect(Host, 5679, [binary, {packet, 0}]),
    ?assertEqual(ok, ConnectRes1),
    ?assertEqual(ok, ConnectRes2),
    ?assertEqual(ok, ConnectRes3).
