-module(ms_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% API functions
-export([create_ms/1,change_state/1,change_lai/1, receiving_setup/2, callsetup/1]).

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
%% @doc Starts a new ms_fsm.
%% @end

create_ms(Tuple)->
    io:format("start_child ~n~p~n",[Tuple]),
    ms_fsm_sup:start_child(Tuple).

%% @spec change_state(Value) -> Result
%%    Value = term()
%%    Result = atom()
%%
%% @doc Sends a request to change the current state of ms_fsm.
%% @end

change_state(Tuple)->
    io:format("change_state ~n~p~n",[Tuple]),
    ms_fsm:send_event(Tuple).

%% @spec change_lai(Value) -> Result
%%    Value = term()
%%    Result = atom()
%%
%% @doc Sends a request to change current location area of the MS.
%% @end
change_lai({IMSI,New_LAI})->
    io:format("change_lai ~n~p~n~p~n",[IMSI,New_LAI]),
    ms_fsm:change_loc_area(IMSI,New_LAI).

receiving_setup(IMSI,Ano)->
ms_fsm:send_event({IMSI,turn_on_active}),
io:format("~n~n~nreceiving_setup ~p ~p ~n",[IMSI,Ano]).

callsetup({2,1,IMSI,LAI,Bno})->
ms_fsm:send_event({IMSI,turn_on_active}),
io:format("~n~n~ncallsetup ~p ~n ~n",[IMSI]),
msc_app:call_setup({2,1,IMSI,LAI,Bno}).

