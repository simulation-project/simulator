%%% Copyright (C) 2012 ITI Egypt.
%%%
%%% The contents of this file are subject to the Erlang Public License,
%%% Version 1.1, (the "License"); you may not use this file except in
%%% compliance with the License. You should have received a copy of the
%%% Erlang Public License along with this software. If not, it can be
%%% retrieved via the world wide web at http://www.erlang.org/.
%%%

%%% Software distributed under the License is distributed on an "AS IS"
%%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%%% the License for the specific language governing rights and limitations
%%% under the License.
%%%
%%% The Initial Developer of the Original Code is Ericsson Utvecklings AB.
%%% Portions created by Ericsson are Copyright 1999, Ericsson Utvecklings
%%% AB. All Rights Reserved.

%%% @doc 
%%%
%%% @copyright 2012 ITI Egypt.
%%% @author Marwa ElShahed <marwa.elshahed@hotmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(ms_fsm).
-behaviour(gen_fsm).

%%% Include files

%%% Start/Stop exports
-export([start_link/1]).

%%% External exports
-export([send_event/1,change_loc_area/2,call_setup/1,send_alert/2,receiving_alert/1,connect_msg/2, reply_msg/2,receiving_answer/1,get_state/1]).
-export([release_msg/1,send_disconnect/1]).

%%% States exports
-export([turn_off/2,turn_on_idle/2,turn_on_active/2,log_info/1]).

%%% Init/Terminate exports
-export([init/1, terminate/3]).

%%% Reply exports
-export([handle_sync_event/4, state_name/2, state_name/3]).

%%% No reply exports
-export([handle_event/3, handle_info/3]).

%%% Code update exports
-export([code_change/4]).

%%% Macros

%%% Data types
%% @private
%% @type st() = #st{}.
%%
%% Representation of the server's state.
%%
%% <dl>
%%   <dt>: </dt><dd>
%%   </dd>
%% </dl>
-record(st, {imsi, lai, timer, periodic_time, normal_time, no_of_trials}).

%%%-----------------------------------------------------------------------------
%%% Start/Stop exports
%%%-----------------------------------------------------------------------------
%% @spec start_link(Param) -> Result
%%    Param = term()
%%    Result = {ok, Pid} | ignore | {error, Error}
%%    Pid = pid()
%%    Error = {already_started, Pid} | term()
%%
%% @doc Starts the server.
%%
%% @see gen_fsm:start_link/4
%% @end
start_link(Param) ->
    gen_fsm:start_link({local, lists:nth(1,Param)}, ?MODULE, Param, []).

%%%-----------------------------------------------------------------------------
%%% External exports
%%%-----------------------------------------------------------------------------

%% @spec turn_off(Event, Std) -> Result
%%    Event = term()
%%    Std = term()
%%    Result = {next_state, NextStn, NextStd} |
%%             {next_state, NextStn, NextStd, Timeout}   |
%%             {reply, Reply, NextStn, NextStd} |
%%             {reply, Reply, NextStn, NextStd, Timeout} |
%%             {stop, Reason, NewStd} |
%%             {stop, Reason, Reply, NewStd} 
%%    Reply = term()
%%    NextStn = atom()
%%    NextStd = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Handles events for the state named turn_off.
%% @end
turn_off(turn_on_idle, Std) ->
    io:format("~p~n",[Std]),
    io:format("turn_on_idle ~n"),
    T_ref = erlang:send_after(Std#st.normal_time,self(),{idle,Std#st.no_of_trials}),
    loc_update(T_ref,{2,1,Std#st.imsi,Std#st.lai}),%% imsi_attach
    P_ref = erlang:send_after(Std#st.periodic_time,self(),repeat),
    {next_state, turn_on_idle, Std#st{timer = P_ref}};
turn_off(turn_on_active, Std) ->
     io:format("~p~n",[Std]),
     io:format("turn_on_active"),
    {next_state, turn_on_active, Std}.

%% @spec turn_on_idle(Event, Std) -> Result
%%    Event = term()
%%    Std = term()
%%    Result = {next_state, NextStn, NextStd} |
%%             {next_state, NextStn, NextStd, Timeout}   |
%%             {reply, Reply, NextStn, NextStd} |
%%             {reply, Reply, NextStn, NextStd, Timeout} |
%%             {stop, Reason, NewStd} |
%%             {stop, Reason, Reply, NewStd} 
%%    Reply = term()
%%    NextStn = atom()
%%    NextStd = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Handles events for the state named turn_on_idle.
%% @end
turn_on_idle(turn_on_active, Std) ->
     io:format("~p~n",[Std]),
     io:format("turn_on_active"),
    %% msc_app:alert_msg(Std#st.imsi,Std#st.lai),
     reply_msg(Std#st.imsi,' : Alert message is sent to MSC'),
    {next_state, turn_on_active, Std};
turn_on_idle(turn_off, Std) ->
    io:format("~p~n",[Std]),
    io:format("turn_off"),
	T_ref = erlang:send_after(Std#st.normal_time,self(),{off,Std#st.no_of_trials}),
    %%T_ref = erlang:send_after(30000,self(),{off,3}),
    loc_update(T_ref,{2,4,Std#st.imsi,Std#st.lai}),%%imsi_deattach
    erlang:cancel_timer(Std#st.timer),
    {next_state, turn_off, Std}.
%% @spec turn_on_active(Event, Std) -> Result
%%    Event = term()
%%    Std = term()
%%    Result = {next_state, NextStn, NextStd} |
%%             {next_state, NextStn, NextStd, Timeout}   |
%%             {reply, Reply, NextStn, NextStd} |
%%             {reply, Reply, NextStn, NextStd, Timeout} |
%%             {stop, Reason, NewStd} |
%%             {stop, Reason, Reply, NewStd} 
%%    Reply = term()
%%    NextStn = atom()
%%    NextStd = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Handles events for the state named turn_on_active.
%% @end
turn_on_active(turn_on_idle,Std)->
    io:format("~p~n",[Std]),
    io:format("turn_on_idle"),
    %%msc_app:receive_connect(Std#st.imsi,Std#st.lai),
    {next_state, turn_on_idle, Std};
turn_on_active(turn_off, Std) ->
    io:format("~p~n",[Std]),
    io:format("turn_off"),
	T_ref = erlang:send_after(Std#st.normal_time,self(),{off,Std#st.no_of_trials}),
    %%T_ref = erlang:send_after(30000,self(),{off,3}),
    loc_update(T_ref,{2,4,Std#st.imsi,Std#st.lai}),%%imsi_deattach
    erlang:cancel_timer(Std#st.timer),
    {next_state, turn_off, Std}.

%%%-----------------------------------------------------------------------------
%%% Init/Terminate exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec init(Args) -> Result
%%    Args = term()
%%    Result = {ok, Stn, Std} | 
%%             {ok, Stn, Std, Timeout} |
%%             ignore | 
%%             {stop, Reason}
%%    Stn = atom()
%%    Std = term()
%%    Timeout = int()
%%    Reason = term()
%%
%% @doc Initializes the the fsm.
%% @end
init(Param) ->
	{ok, Periodic_time} = application:get_env(ms, periodic_time),
	{ok, Normal_time} = application:get_env(ms, normal_time),
	{ok, N} = application:get_env(ms, no_of_trials),
    {ok, turn_off, #st{imsi = lists:nth(1,Param),lai = lists:nth(2,Param), periodic_time = Periodic_time, normal_time = Normal_time, no_of_trials = N }}.
%% @private
%% @spec terminate(Reason, Stn, Std) -> ok
%%    Reason = normal | shutdown | term()
%%    Stn = atom()
%%    Std = term()
%%
%% @doc Shutdown the fsm.
%%
%% The return value is ignored by the server.
%% @end
terminate(_Reason, _Stn, _Std) ->
    io:format("exittttinggg"),
    exit.

%%%-----------------------------------------------------------------------------
%%% Reply exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec handle_sync_event(Event, From, Stn, Stn) -> Result
%%    Event = term()
%%    From = {pid(), Tag}
%%    Stn = atom()
%%    Std = term()
%%    Result = {next_state, NextStn, NextStd} |
%%             {next_state, NextStn, NextStd, Timeout}   |
%%             {reply, Reply, NextStn, NextStd} |
%%             {reply, Reply, NextStn, NextStd, Timeout} |
%%             {stop, Reason, NewStd} |
%%             {stop, Reason, Reply, NewStd}
%%    Reply = term()
%%    NextStateName = atom()
%%    NextStateData = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Handles events received via 
%% <u>gen_fsm:sync_send_all_state_event/2,3</u>.
%% @end
handle_sync_event(_Event, _From, Stn, Std) ->
    {reply, ok, Stn, Std}.

%% @private
%% @spec state_name(Event, From, Std) -> Result
%%    Event = term()
%%    From = {pid(), Tag}
%%    Std = term()
%%    Result = {next_state, NextStn, NextStd} |
%%             {next_state, NextStn, NextStd, Timeout}   |
%%             {reply, Reply, NextStn, NextStd} |
%%             {reply, Reply, NextStn, NextStd, Timeout} |
%%             {stop, Reason, NewStd} |
%%             {stop, Reason, Reply, NewStd} 
%%    Reply = term()
%%    NextStn = atom()
%%    NextStd = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Handles events for the state named state_name.
%% @end
state_name(_Event, _From, Std) ->
    {reply, ok, state_name, Std}.

%%%-----------------------------------------------------------------------------
%%% No reply exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec handle_event(Event, Stn, Std) -> Result
%%    Event = term()
%%    Stn = atom()
%%    Std = term()
%%    Result = {next_state, NextStn, NextStd} |
%%             {next_state, NextStn, NextStd, Timeout} |
%%             {stop, Reason, NewStd} 
%%    NextStn = atom()
%%    NextStd = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Handles events received by <u>gen_fsm:send_all_state_event/2</u>.
%% @end
handle_event({send_alert,Ano}, turn_on_idle,Std) ->
	io:format("send_alert ~n~n"),
    msc_app:receiving_alert({1,5,Std#st.imsi,Std#st.lai}),
	IMSI = atom_to_list(Std#st.imsi),
	Msg1 = string:concat("receiving_call,",IMSI),
	Ano_str = atom_to_list(Ano),
	Msg2 = string:concat(Msg1,","),
	Msg3 = string:concat(Msg2,Ano_str),
	MSG = list_to_atom(Msg3),
	request_handler:erlang_send2(MSG),%%Ringing
    reply_msg(Std#st.imsi,' : Sending Alert message to MSC'),
    {next_state,turn_on_idle, Std};

handle_event(receive_alert, turn_on_idle,Std) ->
	io:format("receive_alert ~n~n"),
    %%msc_app:receiving_alert({1,5,Std#st.imsi,Std#st.lai}),
	IMSI = atom_to_list(Std#st.imsi),
	Msg = string:concat("alert_msg,",IMSI),
	MSG = list_to_atom(Msg),
	request_handler:erlang_send2(MSG),%%Alert
    reply_msg(Std#st.imsi,' : Sending Alert message to MSC'),
    {next_state,turn_on_idle, Std};

handle_event(release_msg,turn_on_active,Std)->
    io:format("release_msg~n"),
    msc_app:release_complete({5,6,Std#st.imsi,Std#st.lai}),
    {next_state,turn_on_idle, Std};

handle_event(send_disconnect,turn_on_active,Std)->
    io:format("send_disconnect~n"),
    msc_app:release_msg({5,7,Std#st.imsi,Std#st.lai}),
    {next_state,turn_on_active, Std};

handle_event(get_state, Stn,Std) ->
	io:format("get_state : ~p~n~n",[Stn]),
	%%IMSI = atom_to_list(Std#st.imsi),
	%%Msg1 = string:concat("ms_state,",IMSI),
	%%Msg2 = string:concat(Msg1,atom_to_list(Stn)),
	%%MSG = list_to_atom(Msg2),
	%%request_handler:erlang_send2(MSG),%%get_state
        ms_app:reply_msg(Std#st.imsi,' : Sending Mobile Station State: ',Stn),
    {next_state,Stn, Std};

handle_event(Event, turn_on_idle, Std) ->
	T_ref = erlang:send_after(Std#st.normal_time,self(),{normal,Std#st.no_of_trials}),
    %%T_ref = erlang:send_after(30000,self(),{normal,3}),
    loc_update(T_ref,{2,2,Std#st.imsi,Event}),%%normal_loc_update
    {next_state, turn_on_idle, Std#st{lai = Event}};
handle_event(_Event, Stn, Std) ->
    {next_state, Stn, Std}.
%% @private
%% @spec handle_info(Info, Stn, Std) -> Result
%%    Info = term()
%%    Stn = atom()
%%    Std = term()
%%    Result = {next_state, NextStn, NextStd} |
%%             {next_state, NextStn, NextStd, Timeout} |
%%             {stop, Reason, NewStd}
%%    NextStn = atom()
%%    NextStd = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Called on reception of any other messages than a synchronous or
%% asynchronous event.
%% @end
handle_info(repeat, Stn, Std) ->
    io:format("repeat"),
    %%loc_update(T_ref,{2,3,Std#st.imsi,Std#st.lai}),
    periodic_loc_update(Std#st.imsi,Std#st.lai),
    reply_msg(Std#st.imsi,' : periodic location update is sent'),
    P_ref = erlang:send_after(Std#st.periodic_time,self(),repeat),
	%%P_ref = erlang:send_after(30000,self(),repeat),
    {next_state, Stn, Std#st{timer = P_ref}};

handle_info({idle,0},Stn,Std) ->
    io:format("turn_on_idle request failed"),
    erlang:cancel_timer(Std#st.timer),
    reply_msg(Std#st.imsi,' : turn_on_idle idle request failed'),
    {next_state, Stn, Std};
handle_info({idle,N},Stn,Std) ->
    io:format("idle request retry "),
	T_ref = erlang:send_after(Std#st.normal_time,self(),{idle,N-1}),
    %%T_ref = erlang:send_after(30000,self(),{idle,N-1}),
    loc_update(T_ref,{2,1,Std#st.imsi,Std#st.lai}),%%imsi_attach
    {next_state, Stn, Std};

handle_info({off,0},Stn,Std) ->
    io:format("turn_off request failed"),
    reply_msg(Std#st.imsi,' : turn_off request failed'),
    {next_state, Stn, Std};
handle_info({off,N},Stn,Std) ->
    io:format("off request retry "),
	T_ref = erlang:send_after(Std#st.normal_time,self(),{off,N-1}),
    %%T_ref = erlang:send_after(30000,self(),{off,N-1}),
    loc_update(T_ref,{2,4,Std#st.imsi,Std#st.lai}),%%imsi_deattach
    erlang:cancel_timer(Std#st.timer),
    {next_state, Stn, Std};

handle_info({normal,0},Stn,Std)->
    io:format("normal update request failed"),
    reply_msg(Std#st.imsi,' : normal update request failed'),
    {next_state, Stn, Std};
handle_info({normal,N},Stn,Std)->
    io:format("normal request retry "),
	T_ref = erlang:send_after(Std#st.normal_time,self(),{normal,N-1}),
    %%T_ref = erlang:send_after(30000,self(),{normal,N-1}),
    loc_update(T_ref,{2,2,Std#st.imsi,Std#st.lai}),%%normal_loc_update
    {next_state, Stn, Std};

handle_info(_Info, Stn, Std) ->
    {next_state, Stn, Std}.

%% @private
%% @spec state_name(Event, Std) -> Result
%%    Event = timeout | term()
%%    Std = term()
%%    Result = {next_state, NextStn, NextStd} |
%%             {next_state, NextStn, NextStd, Timeout} |
%%             {stop, Reason, NewStd}
%%    NextStn = atom()
%%    NextStd = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Handles events for the state name state_name.
%% @end
state_name(_Event, Std)->    
     {next_state, next_state_name, Std}.
%%%-----------------------------------------------------------------------------
%%% Code update exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec code_change(OldVsn, Stn, Std, Extra) -> Result
%%    OldVsn = undefined | term()
%%    Stn = term()
%%    Std = term()
%%    Extra = term()
%%    Result = {ok, NextStn, NewStd}
%%    NextStn = atom()
%%    NewStd = term()
%%
%% @doc Converts the process state when code is changed.
%% @end
code_change(_OldVsn, Stn, Std, _Extra) ->
    {ok, Stn, Std}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------
%%@private
%% @spec loc_update(Ref,Tuple) -> Result
%%    Ref = reference()
%%    Tuple = term()
%%    Result = Time | atom()
%%    Time = integer()		
%%
%% @doc Sends location update request to MSC.
%% @end
loc_update(T_ref,{First,Second,IMSI,LAI})->
    case msc_app:location_update_request({First,Second,IMSI,LAI})of
	ok ->
	    io:format("request{~p,~p,~p,~p} is sent to msc_app",[First,Second,IMSI,LAI]),
	     reply_msg(IMSI,' : request sent to MSC'),
	    erlang:cancel_timer(T_ref);
	_ ->
	    ok
    end.

%%@private
%% @spec periodic_loc_update(IMSI, LAI) -> Result
%%    IMSI = term()
%%    LAI = term()
%%    Result = atom()
%%
%% @doc Sends Periodic location update request to MSC.
%% @end

periodic_loc_update(IMSI, LAI)->
    case msc_app:location_update_request({2,3,IMSI, LAI}) of
	ok ->
	    %%erlang:cancel_timer(T_ref),
	    reply_msg(IMSI,' : request sent to MSC'),
	    io:format("request sent to msc_app:periodic_loc_update~n~n~n"),
	    done;
	_ ->
	    ok
    end.

%%@private
%% @spec reply_msg(Var,Msg) -> Result
%%    Var = term()
%%    Msg = term()
%%    Result = atom()
%%
%% @doc Sends confirmation messages to the user.
%% @end
reply_msg(Var,Msg) ->
    Z = atom_to_list('MS '),
    V=atom_to_list(Var),
    K = string:concat(Z,V),
    Msgs=atom_to_list(Msg),
    Ms=string:concat(K,Msgs),
    M=list_to_atom(Ms),
    request_handler:erlang_send(M),
    log_info(M),
    ok.
%%%-----------------------------------------------------------------------------
%%% API functions
%%%-----------------------------------------------------------------------------

%% @spec send_event(Value) -> Result
%%    Value = tuple()
%%    Result = atom() 
%% @doc Sends an event asynchronously to ms_fsm.
%% @end
send_event({MS,Event})->
    Reply = gen_fsm:send_event(MS,Event),
    io:format("~p~n",[Event]),
    Reply.

%% @spec change_loc_area(IMSI, New_LAI) -> Result
%%    IMSI = term()
%%    LAI = term()
%%    Result = atom()
%%
%% @doc Sends new location info.
%% @end
change_loc_area(IMSI,New_LAI) -> 
    gen_fsm:send_all_state_event(IMSI,New_LAI).


%% @spec call_setup(Value) -> Result
%%    Value = {2,1, IMSI, LAI, Bno}
%%    IMSI = atom()
%%    LAI = atom()
%%    Bno = atom()
%%    Result = atom() 
%% @doc Sends a call setup request to MSC.
%% @end

call_setup({2,1,IMSI,LAI,Bno})->
    msc_app:call_setup({2,1,IMSI,LAI,Bno}).

%% @spec send_alert(IMSI,Ano) -> Result
%%    IMSI = atom()
%%    Ano = atom()
%%    Result = atom() 
%% @doc Sends an alert message to MSC.
%% @end
send_alert(IMSI,Ano)->
    io:format("send_alert to ~p~n",[Ano]),
    gen_fsm:send_all_state_event(IMSI,{send_alert,Ano}).

%% @spec receiving_alert(IMSI) -> Result
%%    IMSI = atom()
%%    Result = atom() 
%% @doc Receives an alert message from MSC.
%% @end
receiving_alert(IMSI)->
    gen_fsm:send_all_state_event(IMSI,receive_alert).

%% @spec connect_msg(IMSI,LAI) -> Result
%%    IMSI = atom()
%%    LAI = atom()
%%    Result = atom() 
%% @doc Sends a connect message to MSC.
%% @end
connect_msg(IMSI,LAI)->
    msc_app:receive_connect({1,6,IMSI,LAI}),
    ms_fsm:send_event({IMSI,turn_on_active}).

%% @spec receiving_answer(IMSI) -> Result
%%    IMSI = atom()
%%    Result = atom() 
%% @doc Sends an alert message to MSC.
%% @end
receiving_answer(IMSI)->
   Msg = string:concat("connected,",atom_to_list(IMSI)),
   MSG = list_to_atom(Msg),
   request_handler:erlang_send2(MSG),
   ms_fsm:send_event({IMSI,turn_on_active}).

%% @spec get_state(IMSI) -> Result
%%    IMSI = atom()
%%    Result = atom() 
%% @doc Returns the state of the MS.
%% @end
get_state(IMSI)->
	gen_fsm:send_all_state_event(IMSI,get_state).

%% @spec log_info(Msg) -> Result
%%    Msg = atom()
%%    Result = atom() 
%% @doc Logs message to a log file.
%% @end
log_info(Msg)->
    {ok, Path} = application:get_env(ms,log_file),
    io:format("~p~n",[Path]),
    M = string:concat(atom_to_list(Msg),"\n"),
    disk_log:open([{name, ms}, {file, Path},{format, external},{type, halt}]),
    disk_log:blog(ms,list_to_binary(M)),
    disk_log:close(ms).


release_msg(IMSI)->
    gen_fsm:send_all_state_event(IMSI,release_msg).

send_disconnect(IMSI)->
     gen_fsm:send_all_state_event(IMSI,send_disconnect).
