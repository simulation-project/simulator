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
%%% @author Esraa Adel <esraa.elmelegy@hotmail.com>
%%% @author Sherif Ashraf <sherif_ashraf89@hotmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(msc_ch).
-behaviour(gen_server).

%%% Include files

%%% Start/Stop exports
-export([start_link/1, stop/1]).


%%% Init/Terminate exports
-export([init/1, terminate/2]).

%%% Handle messages exports
-export([handle_call/3, handle_cast/2, handle_info/2]).

%%% Code update exports
-export([code_change/3]).

%%% External exports
-export([location_update_request/2, insert_subscriber_data/3, check_msc_spc/3]).

-compile([export_all]).
%%% Macros

%%% Data types

%%%-----------------------------------------------------------------------------
%%% Start/Stop exports
%%%-----------------------------------------------------------------------------
%% @spec start_link(Name) -> Result
%%    Name = atom()
%%    Result = {ok, Pid} | ignore | {error, Error}
%%    Pid = pid()
%%    Error = {already_started, Pid} | term()
%%
%% @doc Starts new MSC server.
%%
%% @see gen_server
%% @see start/0
%% @end
start_link(Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name], []).% gen_server call init that is in this module


%% @spec stop(St) -> ok
%%    St = term()
%%
%% @doc Stops the application.
%% @end
stop(_St) ->
    ok.

%%%-----------------------------------------------------------------------------
%%% Init/Terminate exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec init(Args) -> Result
%%    Args = term()
%%    Result = {ok, St} | {ok, St, Timeout} | ignore | {stop, Reason}
%%    St = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Initiates the server

init(_Name) ->
    {ok, []}.

%% @private
%% @spec terminate(Reason, St) -> ok
%%    Reason = normal | shutdown | term()
%%    St = term()
%%
%% @doc Shutdown the server.
%%
%% Return value is ignored by <u>gen_server</u>.
%% @end
terminate(_Reason, _St) ->
    ok.
%%%-----------------------------------------------------------------------------
%%% External exports
%%%-----------------------------------------------------------------------------
%% @spec location_update_request(Parameter, MSC) -> Result
%%    Result = ok   
%%    Parameter = {2,1,IMSI,LAI} | 
%%                {2, 2, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom() 
%%    MSC = atom()
%% @doc This function is called when the mobile station send location update request
%% to update it's location and state in the VLR and HLR.
%% @end
location_update_request({2, 1, IMSI, LAI}, MSC)->
    gen_server:cast(MSC, {2, 1, IMSI, LAI,MSC});

location_update_request({2, 2, IMSI, LAI}, MSC)->
    gen_server:cast(MSC, {2, 2, IMSI, LAI,MSC}).

%% @spec insert_subscriber_data(IMSI,INFO,SPC) -> Result
%% Result = ok
%% IMSI = atom()
%% SPC = atom()
%% INFO = atom()
%% @doc This function is called when the HLR sends the ISD message
%% to the MSC to insert the subsceiber data in the VLR.
%% @end
insert_subscriber_data(MSC, IMSI, idle)->
 gen_server:cast(MSC, {6, 2, IMSI, idle}).

%% @spec check_msc_spc(MSC, SPC, GT) -> Result
%%    Result = not_found | MSC 
%%    MSC = atom() 
%%    SPC = atom()
%%    GT = atom() 
%% @doc This function is called to check that both the SPC and GT 
%% belong to a configured MSC.
%% @end
check_msc_spc(_MSC, SPC, GT)-> 
    io:format("handle call chechiiiiing"),
    io:format("spc isssssssss ~p",[SPC]),
    Reply=msc_db:get_msc_name({SPC,GT}),
    io:format("checking replyyy: ~p",[Reply]),
    io:format("~n chechiiiiing"),
    Reply.   

%%%-----------------------------------------------------------------------------
%%%  Handle messages exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec handle_call(Req, From, St) -> Result
%%    Req = term()
%%    From = {pid(), Tag}
%%    St = term()
%%    Result = {reply, Reply, NewSt} |
%%             {reply, Reply, NewSt, Timeout} |
%%             {noreply, NewSt} |
%%             {noreply, NewSt, Timeout} |
%%             {stop, Reason, Reply, NewSt} |
%%             {stop, Reason, NewSt}
%%    Reply = term()
%%    NewSt = term()
%%    Timeout = int() | infinity
%%    Reason = term()
%%
%% @doc Handling call messages.
%%
%% <ul>
%%   <li>On <u>{stop, Reason, Reply, NewSt}</u> {@link terminate/2} is
%%   called.</li>
%%   <li>On <u>{stop, Reason, NewSt}</u> {@link terminate/2} is
%%   called.</li>
%% </ul>
%%
%% @see terminate/2
%% @end
handle_call(_Req, _From, St) ->
    {reply, [], St}.

%% @private
%% @spec handle_cast(Req, List) -> Result
%%    Req = {2, 1, IMSI, LAI, MSC} |
%%          {2, 2, IMSI, LAI, MSC} |
%%          {6, 2, IMSI, idle}
%%    IMSI = atom()
%%    LAI = atom()
%%    MSC = atom()
%%    Result = {noreply, NewSt} |
%%             {stop, Reason, NewSt}
%%    NewSt = term()
%%    Timeout = int() | infinity
%%    Reason = normal | term()
%%
%% @doc Handling cast messages.
%%
%% <ul>
%%   <li>On <u>{stop, Reason, NewSt}</u> {@link terminate/2} is
%%   called.</li>
%% </ul>
%%
%% @see terminate/2
%% @end
handle_cast({2, 1, IMSI, LAI, MSC}, List) ->
    VLR=msc_db:get_VLR(MSC),
    io:format("vooooo ~p",[VLR]),
    msc_db:insert_subscriber(IMSI,LAI,MSC,VLR),
    Sub_IMSI=string:substr(atom_to_list(IMSI),6),
    MGT=string:concat("2010",Sub_IMSI),
    Sub_MGT=string:substr(MGT,1,5),
    Sub_MGT_DB=list_to_atom(Sub_MGT),
    SPC=msc_db:get_SPC(Sub_MGT_DB),
    io:format("Name of SPC ~p~n", [SPC]),
    Reply=hlr_mgr:imsiExist(SPC,IMSI),
    check_hlr(Reply, {IMSI, VLR, SPC}),
    {noreply, List};

handle_cast({2, 2, IMSI, LAI, MSC}, List) ->
    MSC_Name = msc_db:check_msc_imsi(MSC, IMSI),
    normal_location_update(MSC_Name, IMSI, LAI),
    {noreply, List};

handle_cast({6, 2, IMSI, idle}, List) ->
    io:format("~n vvvvvvvv"),
    msc_db:update_subscriber_info(IMSI, idle),
    {noreply, List}.

%% @private
%% @spec handle_info(Info, St) -> Result
%%    Info = timeout | term()
%%    St = term()
%%    Result = {noreply, NewSt} |
%%             {noreply, NewSt, Timeout} |
%%             {stop, Reason, NewSt}
%%    NewSt = term()
%%    Timeout = int() | infinity
%%    Reason = normal | term()
%%
%% @doc Handling all non call/cast messages
%%
%% <ul>
%%   <li>On <u>{stop, Reason, NewSt}</u> {@link terminate/2} is
%%   called.</li>
%% </ul>
%%
%% @see terminate/2
%% @end
handle_info(_Info, St) ->
    {noreply, St}.

%%%-----------------------------------------------------------------------------
%%% Code update exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec code_change(OldVsn, St, Extra) -> {ok, NewSt}
%%    OldVsn = undefined | term()
%%    St = term()
%%    Extra = term()
%%    NewSt = term()
   
%% @doc Converts the process state when code is changed.
%% @end
code_change(_OldVsn, St, _Extra) ->
    {ok, St}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------
check_hlr(false, {})->
    io:format("falseeeeeeee");

check_hlr(ok, {IMSI, VLR, SPC}) ->
    io:format("trueeeeeeeeee"),
    GT = msc_db:get_GT(VLR),
    update_location(IMSI, VLR, GT, SPC).


normal_location_update(not_found, _IMSI, _LAI)->
    ok;
normal_location_update(_, IMSI, LAI) ->
     msc_db:update_location(IMSI, LAI),
    ok.

update_location(IMSI, VLR, GT,SPC)->
    io:format("update_location in child"),
    hlr_mgr:update_location({IMSI, VLR, GT},SPC),
    io:format("location updated in child"),
    ok.

    
    
    
