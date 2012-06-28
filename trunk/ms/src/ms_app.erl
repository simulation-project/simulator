-module(ms_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% API functions
-export([create_ms/1,change_state/1,change_lai/1,call_setup/1,receiving_setup/2,receiving_alert/1,connect_msg/2,receiving_answer/1, get_state/1,reply_msg/3]).
-export([disconnect_msg/1,release_msg/1,send_disconnect/1,release_complete/1]).
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

%% @spec receiving_setup(IMSI,Ano) -> Result
%%    IMSI = term()
%%    Ano = term()
%%    Result = atom()
%%
%% @doc receives a setup  message from MSC.
%% @end

receiving_setup(IMSI,Ano)->
    %%ms_fsm:send_event({IMSI,turn_on_active}),
    io:format("receiving_setup ~p  ~p ~n",[IMSI,Ano]),
    reply_msg(IMSI,' : call request received from MSC with ',Ano),
    ms_fsm:send_alert(IMSI,Ano).

%% @spec call_setup(Value) -> Result
%%    Value = term()
%%    Result = atom()
%%
%% @doc Sends a call setup request to MSC.
%% @end

call_setup({IMSI,LAI,Bno})->
    io:format("callsetup ~n"),
    msc_app:call_setup({2,1,IMSI,LAI,Bno}),
    reply_msg(IMSI ,' : call request sent to MSC to ',Bno).

%% @spec receiving_alert(IMSI) -> Result
%%    IMSI = atom()
%%    Result = atom() 
%% @doc Receives an alert message from MSC.
%% @end
receiving_alert(IMSI)->
    %%ms_fsm:send_event({IMSI,turn_on_active}),
    ms_fsm:receiving_alert(IMSI),
    io:format("receiving_alert ~n"),
    ms_fsm:reply_msg(IMSI,' : receiving alert from MSC').

%% @spec connect_msg(IMSI,LAI) -> Result
%%    IMSI = atom()
%%    LAI = atom()
%%    Result = atom() 
%% @doc Sends a connect message to MSC.
%% @end
connect_msg(IMSI,LAI)->
    io:format("connect_msg"),
    ms_fsm:connect_msg(IMSI,LAI).

%% @spec receiving_answer(IMSI) -> Result
%%    IMSI = atom()
%%    Result = atom() 
%% @doc Receiving an answer message from MSC.
%% @end
receiving_answer(IMSI)->
    io:format("receiving_answer"),
    ms_fsm:receiving_answer(IMSI).

%% @spec get_state(IMSI) -> Result
%%    IMSI = atom()
%%    Ano = atom()
%%    Result = atom() 
%% @doc Returns the state of MS.
%% @end
get_state(IMSI)->
	ms_fsm:get_state(IMSI).
	

disconnect_msg({IMSI,LAI})->
    msc_app:receive_disconnect({1,7,IMSI,LAI}).

release_msg(IMSI)->
    ms_fsm:release_msg(IMSI).

send_disconnect(IMSI)->
    ms_fsm:send_disconnect(IMSI).

release_complete(IMSI)->
    ms_fsm:send_event({IMSI,turn_on_idle}).

%% @private
%% @spec reply_msg(MSG1, MSG2, MSG3) -> Result
%%    MSG1 = term()
%%    MSG2 = term()
%%    MSG1 = term()
%%    Result = atom()
%%
%% @doc Sends a confirmation message to the user.
%% @end
reply_msg(Var,Msg,Bno) ->
    Z = atom_to_list('MS '),
    V=atom_to_list(Var),
    K = string:concat(Z,V),
    Msgs=atom_to_list(Msg),
    Ms=string:concat(K,Msgs),
    L = atom_to_list(Bno),
    D = string:concat(Ms,L),
    F = list_to_atom(D),
    request_handler:erlang_send(F),
    ms_fsm:log_info(F),
    ok.
