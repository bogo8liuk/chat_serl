-module(room_test).

-include_lib("eunit/include/eunit.hrl").

-record(room, { id, creator, actual_users }).

should_create_room_test() ->
    Id = "room42", CreatorId = "user42",
    {Res0, State0} = chat_serl_room:handle_cast({create, Id, CreatorId}, orddict:new()),
    ?assertEqual(noreply, Res0),
    Room0 = orddict:fetch(Id, State0),
    ?assertEqual(#room{id = Id, creator = CreatorId, actual_users = [CreatorId]}, Room0).

should_not_create_room_if_existing_test() ->
    Id = "room42", CreatorId = "user42", AnotherUser = "a_random_user",
    InitState = orddict:store(Id, #room{id = Id, creator = AnotherUser,
        actual_users = [AnotherUser]}, orddict:new()),
    {Res0, State0} = chat_serl_room:handle_cast({create, Id, CreatorId}, InitState),
    ?assertEqual(noreply, Res0),
    Room0 = orddict:fetch(Id, State0),
    ?assertEqual(#room{id = Id, creator = AnotherUser, actual_users = [AnotherUser]}, Room0),
    ?assertEqual(1, orddict:size(State0)).

should_list_rooms_test() ->
    Id0 = "room42", Id1 = "another room", UserId0 = "user42",
    {Res0, Rooms0} = chat_serl_room:handle_cast(rooms, orddict:new()),
    ?assertEqual(noreply, Res0),
    ?assertEqual([], Rooms0),
    {_, State1} = chat_serl_room:handle_cast({create, Id0, UserId0}, orddict:new()),
    {Res1, Rooms1} = chat_serl_room:handle_cast(rooms, State1),
    ?assertEqual(noreply, Res1),
    ?assertEqual([#room {id = Id0, creator = UserId0, actual_users = [UserId0]}], Rooms1),
    {_, State2} = chat_serl_room:handle_cast({create, Id1, UserId0}, State1),
    {_, Rooms2} = chat_serl_room:handle_cast(rooms, State2),
    ?assertEqual(2, length(Rooms2)).
