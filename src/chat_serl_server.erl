-module(chat_serl_server).

-behaviour(gen_server).

%%% gen_server callbacks
-export([start_link/1, init/1, handle_call/3, handle_cast/2,
    handle_info/2, terminate/2, code_change/3]).

-record(server_state, {listen_socket}).

start_link(ListenSocket) ->
    gen_server:start_link(?MODULE, ListenSocket, []).

init(ListenSocket) ->
    logger:info("Init server process"),
    gen_server:cast(self(), accept),
    {ok, #server_state{listen_socket = ListenSocket}}.

handle_cast(accept, State = #server_state{listen_socket = ListenSocket}) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    chat_serl_sup:start_worker(),
    logger:info("Accepted request"),
    send(Socket, "Welcome!"),
    {noreply, State#server_state{listen_socket = Socket}};
handle_cast(_, State) ->
    {noreply, State}.

handle_info({tcp, Socket, "quit"}, State) ->
    logger:info("Closing socket"),
    gen_tcp:close(Socket),
    {stop, normal, State};
handle_info({tcp, Socket, Msg}, State) ->
    logger:info("New message: ~p", [Msg]),
    send(Socket, Msg),
    {noreply, State};
handle_info({tcp_closed, _Socket}, State) ->
    logger:info("tcp closed"),
    {stop, normal, State};
handle_info({tcp_error, _Socket, _}, State) ->
    logger:error("tcp error"),
    {stop, normal, State};
handle_info(Arg, State) ->
    logger:error("Unexpected term: ~p", [Arg]),
    {noreply, State}.

send(Socket, Str) ->
	ok = gen_tcp:send(Socket, Str),
	ok = inet:setopts(Socket, [{active, once}]),
	ok.

handle_call(_, _, State) ->
    {noreply, State}.

terminate(_, _) ->
    logger:info("Terminating server process"),
    ok.

code_change(_, Tab, _) ->
    {ok, Tab}.
