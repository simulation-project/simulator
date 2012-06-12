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
-export([send_event/1]).

%%% States exports
-export([turn_off/2,turn_on_idle/2,turn_on_active/2]).

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
-record(st, {imsi, msisdn, lai}).

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
    io:format("turn_on_idle ~n loc_update is Called~n"),
    loc_update(Std#st.imsi,Std#st.lai),
    {next_state, turn_on_idle, Std};
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
    {next_state, turn_on_active, Std};
turn_on_idle(turn_off, Std) ->
    io:format("~p~n",[Std]),
    io:format("turn_off"),
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
    {next_state, turn_on_idle, Std};
turn_on_active(turn_off, Std) ->
    io:format("~p~n",[Std]),
    io:format("turn_off"),
    {next_state, turn_off, Std}.

%% @spec send_event(Value) -> Result
%%    Value = tuple()
%%    Result = atom() 
%% @doc Sends an event asynchronously to ms_fsm.
%% @end
send_event({MS,Event})->
    Reply = gen_fsm:send_event(MS,Event),
    io:format("~p~n",[Event]),
    Reply.


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
    {ok, turn_off, #st{imsi = lists:nth(1,Param), msisdn = lists:nth(2,Param), lai = lists:nth(3,Param)}}.
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
    ok.

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

%%%-----------------------------------------------------------------------------
%%% API functions
%%%-----------------------------------------------------------------------------

%% @spec loc_update(IMSI, LAI) -> Result
%%    IMSI = term()
%%    LAI = term()
%%    Result = atom()
%%
%% @doc Sends location update request to MSC.
%% @end

loc_update(IMSI, LAI)->
    %%_MSC = current_msc(),
    msc:location_update({2,1,IMSI, LAI}),
    ok.

%%current_msc()->
%%    msc.

