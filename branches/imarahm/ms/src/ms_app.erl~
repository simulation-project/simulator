-module(ms_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% API functions
-export([start_child/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    ms_sup:start_link().

stop(_State) ->
    ok.

%% ===================================================================
%% API functions
%% ===================================================================
%% @spec start_child(Value) -> Result
%%    Value = term()
%%    Result = atom()
%%
%% @doc Sends location update request to MSC.
%% @end

start_child(Tuple)->
    io:format("start_child ~n~p~n",[Tuple]),
    ms_fsm_sup:start_child(Tuple).
