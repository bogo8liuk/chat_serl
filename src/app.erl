%%%-------------------------------------------------------------------
%% @doc chat_serl public API
%% @end
%%%-------------------------------------------------------------------

-module(app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    logger:set_primary_config(level, info),
    sup:start_link().

stop(_State) ->
    ok.

%% internal functions
