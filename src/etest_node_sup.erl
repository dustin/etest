-module(etest_node_sup).

-export([start_link/4]).

-export([init/4]).

-define(SERVER, ?MODULE).

start_link(Mod, Func, Args, Count) ->
    spawn_link(?MODULE, init, [Mod, Func, Args, Count]).

init(Mod, Func, Args, Count) ->
    lists:map(fun(_N) ->
                      spawn_link(Mod, Func, Args)
              end, lists:seq(1, Count)).
