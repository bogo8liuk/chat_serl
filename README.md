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

Then you should find the executable in `_build/default/rel/chat_serl/bin/`
directory.
