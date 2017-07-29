-module(channel).
-behaviour(gen_server).

%% API exports
-export([start_link/0, stop/1, send/2, recv/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%====================================================================
%% API functions
%%====================================================================
start_link() ->
    gen_server:start_link(?MODULE, [], []).

stop(Pid) ->
    gen_server:call(Pid, terminate).

send(Pid, Msg) ->
    io:format("send~n"),
    gen_server:call(Pid, {send_request, Msg}).

recv(Pid) ->
    io:format("recv~n"),
    gen_server:call(Pid, {recv_request}).

	
%%====================================================================
%% Server functions
%%====================================================================
init([]) -> {ok, {[], []}}.

handle_call(terminate, _From, _) ->
    io:format("receive terminate~n"),
    {stop, normal, ok, {[], []}};
handle_call({recv_request}, Receiver, {[], []}) ->
    io:format("receive recv_request~n"),
    {noreply, {[], [Receiver]}};
handle_call({send_request, Msg}, Sender, {[], []}) ->
    io:format("receive send_request~n"),
    {noreply, {{[Sender], Msg}, []}};
handle_call({recv_request}, Receiver, {{Senders, Msg}, []}) ->
    io:format("receive recv_request~n"),
    gen_server:reply(Receiver, {ok, Msg}),
    lists:foreach(fun(Sender) -> gen_server:reply(Sender, ok) end, Senders),
    {noreply, {[], []}};
handle_call({send_request, Msg}, Sender, {{Senders, Msg}, []}) ->
    io:format("receive send_request~n"),
    {noreply, {{[Sender | Senders], Msg}, []}};
handle_call({recv_request}, Receiver, {[], Receivers}) ->
    io:format("receive recv_request~n"),
    {noreply, {[], [Receiver | Receivers]}};
handle_call({send_request, Msg}, Sender, {[], Receivers}) ->
    io:format("receive send_request~n"),
    lists:foreach(fun(Receiver) -> gen_server:reply(Receiver, {ok, Msg}) end, Receivers),
    gen_server:reply(Sender, ok),
    {noreply, {[], []}}.

handle_cast(_, State) ->
    {noreply, State}.

handle_info(Msg, State) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, State}.

terminate(normal, _) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
    