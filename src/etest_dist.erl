-module(etest_dist).

-export([start_slaves/3, start_slaves/4]).

%
% Installs and starts code on every known node.
% Returns a list of started PIDs (one per node).
%
start_slaves(Modules, StartMod, StartArgs) ->
    _World = (catch net_adm:world()),
    start_slaves(Modules, StartMod, StartArgs, nodes(known)).

%
% Installs and starts code on each listed node.
% Returns a list of started PIDs (one per node).
%
start_slaves(Modules, StartMod, StartArgs, Nodes)
  when is_list(Modules), is_atom(StartMod),
       is_list(StartArgs), is_list(Nodes) ->
    % List all the nodes that aren't the current node
	OtherNodes = lists:filter(fun(N) -> N =/= node() end,
                              Nodes),
    % Install all the required code on them.
	error_logger:info_msg("Loading code on:  ~p~n", [OtherNodes]),
    lists:foreach(fun(Mod) -> rload_module(Mod, Nodes) end, Modules),

	% Required code is loaded, start 'em up
	lists:map(fun(N) -> spawn_link(N, StartMod, init, StartArgs) end, Nodes).

rload_module(Mod, Nodes) ->
    {Mod, Bin, File} = code:get_object_code(Mod),
	{BinaryReplies, _} = rpc:multicall(Nodes, code, load_binary,
                                       [Mod, File, Bin]),

	% Validate the multicall
	lists:foreach(fun({module, Mod2}) -> Mod2 = Mod end, BinaryReplies),
	error_logger:info_msg("Loaded code for %s:  ~p~n", [Mod, BinaryReplies]).
