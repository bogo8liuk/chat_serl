-module(tcp).

-export([listen/1, accept/1]).

listen(Port) ->
    gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]).

accept(ListenSocket) ->
    gen_tcp:accept(ListenSocket).
        %{ok,S} ->
        %    io:format("ALL OK!"),
        %    accept(ListenSocket);
        %Other ->
        %    io:format("accept returned ~w - goodbye!~n",[Other]),
        %    ok
    
