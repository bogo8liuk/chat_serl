%%%-------------------------------------------------------------------
%% @doc chat_serl public API
%% @end
%%%-------------------------------------------------------------------

-module(chat_serl_app).

-behaviour(application).

-export([start/2, stop/1]).

-import(tcp, [listen/1, accept/1]).

start(_StartType, _StartArgs) ->
    logger:set_primary_config(level, info),
    chat_serl_sup:start_link().

stop(_State) ->
    ok.
