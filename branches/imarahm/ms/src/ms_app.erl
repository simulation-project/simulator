-module(ms_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% API functions
-export([create_ms/1,change_state/1]).

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

%% @spec create_ms(Value) -> Result
%%    Value = term()
%%    Result = atom()
%%
%% @doc Sends location update request to MSC.
%% @end

create_ms(Tuple)->
    io:format("start_child ~n~p~n",[Tuple]),
    ms_fsm_sup:start_child(Tuple).

%% @spec change_state(Value) -> Result
%%    Value = term()
%%    Result = atom()
%%
%% @doc Sends location update request to MSC.
%% @end

change_state(Tuple)->
    io:format("change_state ~n~p~n",[Tuple]),
    ms_fsm:send_event(Tuple).
