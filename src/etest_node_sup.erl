-module(etest_node_sup).

-behaviour(supervisor).

-export([start_link/4]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link(Mod, Func, Args, Count) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, {Mod, Func, Args, Count}).

init({Mod, Func, Args, Count}) ->
    Children = children(Mod, Func, Args, Count),
    error_logger:info_msg("Starting children:  ~p~n", [Children]),
    {ok, {{one_for_all,5,10}, Children}}.

children(Mod, Func, Args, Count) ->
    lists:map(fun (N) ->
                      ChildName = list_to_atom(lists:concat(["worker", N])),
                      {ChildName, {Mod, Func, Args},
                       transient, 2000, worker, [Mod]}
              end, lists:seq(1, Count)).
