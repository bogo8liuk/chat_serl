-module(room_test).

-include_lib("eunit/include/eunit.hrl").

-record(room, { id, creator, actual_users }).

should_create_room_test() ->
    Id = "room42", CreatorId = "user42",
    {Res0, State0} = chat_serl_room:handle_cast({create, Id, CreatorId}, orddict:new()),
    ?assertEqual(noreply, Res0),
    Room0 = orddict:fetch(Id, State0),
    ?assertEqual(#room{id = Id, creator = CreatorId, actual_users = [CreatorId]}, Room0).

should_not_create_room_test() ->
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

should_join_room_test() ->
    Id0 = "room42", UserId0 = "user42", UserId1 = "xX another user Xx",
    {Res0, State0} = chat_serl_room:handle_cast({join, UserId1, Id0}, orddict:new()),
    ?assertEqual(noreply, Res0),
    {_, Rooms0} = chat_serl_room:handle_cast(rooms, State0),
    ?assertEqual([], Rooms0),
    {_, State1} = chat_serl_room:handle_cast({create, Id0, UserId0}, State0),    
    {Res2, State2} = chat_serl_room:handle_cast({join, UserId1, Id0}, State1),
    ?assertEqual(noreply, Res2),
    Room = orddict:fetch(Id0, State2),
    ?assertEqual(2, length(Room#room.actual_users)),
    ?assert(lists:member(UserId0, Room#room.actual_users)),
    ?assert(lists:member(UserId1, Room#room.actual_users)).

should_not_join_room_test() ->
    Id0 = "room42", UserId0 = "user42", UserId1 = "xX another user Xx",
    {_, State0} = chat_serl_room:handle_cast({create, Id0, UserId0}, orddict:new()),
    {Res1, State1} = chat_serl_room:handle_cast({join, UserId0, Id0}, State0),
    ?assertEqual(noreply, Res1),
    Room0 = orddict:fetch(Id0, State1),
    ?assertEqual(1, length(Room0#room.actual_users)),
    ?assert(lists:member(UserId0, Room0#room.actual_users)),
    ?assert(not lists:member(UserId1, Room0#room.actual_users)),
    {_, State2} = chat_serl_room:handle_cast({join, UserId1, Id0}, State1),
    Room1 = orddict:fetch(Id0, State2),
    ?assertEqual(2, length(Room1#room.actual_users)),
    ?assert(lists:member(UserId0, Room1#room.actual_users)),
    ?assert(lists:member(UserId1, Room1#room.actual_users)),
    {_, State3} = chat_serl_room:handle_cast({join, UserId1, Id0}, State2),
    Room2 = orddict:fetch(Id0, State3),
    ?assertEqual(2, length(Room2#room.actual_users)),
    ?assert(lists:member(UserId0, Room2#room.actual_users)),
    ?assert(lists:member(UserId1, Room2#room.actual_users)).
