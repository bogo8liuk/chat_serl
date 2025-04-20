# chat_serl
This is a simple chat server written in Erlang.

## Build
Just run:
```bash
rebar3 compile
```

To make a release:
```bash
rebar3 release
```

## Test
Just run:
```bash
rebar3 eunit
```

### Test the app
Then you should find the executable in `_build/default/rel/chat_serl/bin/`
directory. Open a shell and run the executable in foreground, then open another
shell and run an erlang repl. For a simple test, you could follow these steps:

Get two connections:
```
1> {ok, Socket0} = gen_tcp:connect("localhost", 5678, []).
{ok,#Port<0.5>}
2> {ok, Socket1} = gen_tcp:connect("localhost", 5678, []).
{ok,#Port<0.6>}
```
As the prompt shows, you should match the sockets.

Then you can send messages. You should see logs in application shell which is
running.
```
3> gen_tcp:send(Socket0, "hi").
ok
4> gen_tcp:send(Socket1, "42").
ok
```

Then try to send `"quit"` message to the first socket:
```
5> gen_tcp:send(Socket0, "quit").
ok
```

You cannot send data to the first socket anymore, but you should still be able
to send data to the second socket:
```
6> gen_tcp:send(Socket0, "hii").
{error,closed}
7> gen_tcp:send(Socket1, "a message").
ok
```

In the end, you can `"quit"` the second socket as well:
```
8> gen_tcp:send(Socket1, "quit").
ok
9> gen_tcp:send(Socket1, "a message that will never be sent").
{error,closed}
```
