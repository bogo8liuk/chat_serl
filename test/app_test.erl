-module(app_test).

-include_lib("eunit/include/eunit.hrl").

app_should_start_test() ->
    {StartRes, _} = chat_serl_app:start(any, any),
    ?assertEqual(ok, StartRes).
