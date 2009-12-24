# etest - simple distributed testing

The purpose of this app is to make it easy to run a controlled
parallel test from many erlang nodes concurrently with one simple
central console.

In the most simple cases, you can login to remote machines, start up
erlang distributed nodes (e.g. `erl -sname testing -noshell
-detached`) and then use them as slaves for running tests.

etest delivers the latest code to all your slaves nodes and tells them
to start running.

## Example (using included modules):

    etest_dist:start_slaves([etest_sample, etest_node_sup],
                            etest_node_sup, start_children,
                            [etest_sample, start, [2], 5]).

This will use `net_adm:world()` to visit `.hosts.erlang` if possible
and will then deploy and run 5 instances of `etest_sample:start/1`
with an argument of `2` on every node it finds.
