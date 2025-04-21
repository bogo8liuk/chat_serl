-module(chat_serl_room).

-behaviour(gen_server).

-export([start_link/1]).
%%% gen_server callbacks
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([handle_continue/2]).
-export([terminate/2]).
-export([code_change/3]).
-export([format_status/1]).

-record(room, { id, creator, actual_users }).

start_link(_) ->
    gen_server:start_link(?MODULE, any, []).

%%% gen_server callbacks
init(_) ->
    gen_server:start_link(?MODULE, [], []).

handle_call(_, _, _) ->
  error(not_implemented).

handle_cast({create, Id, CreatorId}, State) ->
    IsKey = orddict:is_key(Id, State),
    if IsKey -> {noreply, State};
       true ->
          UpdatedState = orddict:store(Id, #room{id = Id, creator = CreatorId,
              actual_users = [CreatorId]}, State),
          {noreply, UpdatedState}
    end;
handle_cast(rooms, State) ->
    {noreply, lists:map(fun({_, V}) -> V end, orddict:to_list(State))}.

handle_info(_, _) ->
  error(not_implemented).

handle_continue(_, _) ->
  error(not_implemented).

terminate(_, _) ->
  error(not_implemented).

code_change(_, _, _) ->
  error(not_implemented).

format_status(_) ->
  error(not_implemented).
