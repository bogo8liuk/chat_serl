%%%-------------------------------------------------------------------
%% @doc chat_serl public API
%% @end
%%%-------------------------------------------------------------------

-module(chat_serl_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    chat_serl_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
