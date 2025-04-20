%%%-------------------------------------------------------------------
%% @doc chat_serl top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(chat_serl_sup).

-behaviour(supervisor).

-export([start_link/0, init/1, start_worker/0]).

-define(PORT, 5678).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_worker() ->
    logger:info("Starting new child"),
    supervisor:start_child(?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    logger:info("Initiating supervisor"),
    {ok, ListenSocket} = gen_tcp:listen(?PORT, [{active, once}]),
    logger:info("Now listening from tcp socket"),
    spawn_link(fun start_worker/0),
    SupFlags = #{
        strategy => simple_one_for_one,
        % Restarting set to max 60 times every 60 minutes
        intensity => 60,
        period => 3600
    },
    ChildSpecs = [{chat_serl_server, {chat_serl_server, start_link, [ListenSocket]},
        temporary, 1000, worker, [chat_serl_server]}],
    {ok, {SupFlags, ChildSpecs}}.
