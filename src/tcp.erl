-module(tcp).

-export([listen/1, accept/1]).

listen(Port) ->
    gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]).

accept(ListenSocket) ->
    case gen_tcp:accept(ListenSocket) of
        {ok, Socket} ->
            logger:info("accepted tcp request"),
            accept(ListenSocket);
        Other ->
            logger:info("accept returned ~w - goodbye!~n", [Other]),
            ok
    end.
