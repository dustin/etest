# etest - simple distributed testing

Example (using included modules):

    etest_dist:start_slaves([etest_sample, etest_node_sup],
                            etest_node_sup, start_children,
                            [etest_sample, start, [2], 5]).

This will use `net_adm:world()` to visit `.hosts.erlang` if possible
and will then deploy and run 5 instances of `etest_sample:start/1`
with an argument of `2` on every node it finds.
