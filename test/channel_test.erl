-module(channel_test).
-include_lib("eunit/include/eunit.hrl").
-import(channel, [start_link/0, stop/1, send/2, recv/1]).

%%====================================================================
%% Tests
%%====================================================================
sender(Ch) ->
    send(Ch, 10).

receiver(Ch) ->
    {ok, Msg} = recv(Ch),
    io:format("Msg: ~p~n", [Msg]),
    ?assert(Msg =:= 10).

recv1send1_test() ->
       {ok, Ch} = start_link(),
       spawn(fun() -> receiver(Ch) end),
       sender(Ch),
       stop(Ch).

send1recv1_test() ->
       {ok, Ch} = start_link(),
       spawn(fun() -> sender(Ch) end),
       receiver(Ch),
       stop(Ch).

recv2send1_test() ->
       {ok, Ch} = start_link(),
       spawn(fun() -> receiver(Ch) end),
       spawn(fun() -> receiver(Ch) end),
       sender(Ch),
       stop(Ch).
