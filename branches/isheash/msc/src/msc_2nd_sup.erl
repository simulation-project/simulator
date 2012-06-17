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
-module(msc_2nd_sup).
-behaviour(supervisor).

%%% Include files

%%% Start/Stop exports
-export([start_link/0, stop/1]).

%%% Internal exports
-export([init/1,start_msc/1, location_update_request/1, insert_subscriber_data/3, check_msc_spc/2]).

%%% Macros
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%%% Data types

%%%-----------------------------------------------------------------------------
%%% Start/Stop exports
%%%-----------------------------------------------------------------------------
%% @spec start_link() -> Result
%%    Result = {ok, Pid} | ignore | {error, Error}
%%    Pid = pid()
%%    Error = {already_started, Pid} | shutdown | term()
%%
%% @doc Starts the supervisor.
%% @end
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


%% @spec stop(St) -> ok
%%    St = term()
%%
%% @doc Stops the application.
%% @end
stop(_St) ->
    ok.

%%%-----------------------------------------------------------------------------
%%% Internal exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec init(Args) -> Result
%%    Args = term()
%%    Result = {ok, {SupFlags, [ChildSpec]}} | ignore | {error, Reason}
%%    SupFlags = {Strategy, MaxR, MaxT}
%%    Strategy = one_far_all | one_for_one | rest_for_one | simple_one_for_one
%%    MaxR = int()
%%    MaxT = int()
%%    ChildSpec = child_spec()
%%
%% @doc Initializes the supervisor.
%% @end
init([]) ->    
    {ok, { {simple_one_for_one, 5, 10}, [?CHILD(msc_ch,worker)]} }.

%%%-----------------------------------------------------------------------------
%%% External exports
%%%-----------------------------------------------------------------------------
%% @spec start_msc(Name) -> Result
%%    Result = {ok, Pid} 
%%    Pid = pid()  
%%    Name = atom() 
%% @doc This function is called to build a msc with the given Name
%% this name is then used to call the module of that msc.
%% @end
start_msc(N)->
    supervisor:start_child(?MODULE, [N]).

%% @spec location_update_request(Parameter) -> Result
%%    Result = ok   
%%    Parameter = {2, 1, IMSI, LAI} |
%%                {2, 2, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom() 
%% @doc This function is called when the mobile station is turned on
%% to update it's location and state in the VLR and HLR.
%% @end
location_update_request({2, 1, IMSI, LAI})->
    MSC = msc_db:get_msc_name({LAI,lai}),
    msc_ch:location_update_request({2, 1, IMSI, LAI}, MSC);

location_update_request({2, 2, IMSI, LAI}) ->
    MSC = msc_db:get_msc_name({LAI,lai}),
    msc_ch:location_update_request({2, 2, IMSI, LAI}, MSC).
    
%% @spec insert_subscriber_data(IMSI, INFO, SPC) -> Result
%% Result = ok
%% IMSI = atom()
%% SPC = atom()
%% INFO = atom()
%% @doc This function is called when the HLR sends the ISD message
%% to the MSC to insert the subsceiber data in the VLR.
%% @end
insert_subscriber_data(IMSI,_INFO,SPC )->
    MSC=msc_db:get_msc_name({SPC,spc}),
    msc_ch:insert_subscriber_data(MSC, IMSI, idle).

%% @spec check_msc_spc(SPC,GT) -> Result
%%    Result = not_found | MSC 
%%    MSC = atom() 
%%    IMSI = atom()
%%    LAI = atom() 
%% @doc This function is called to check that both the SPC and GT 
%% belong to a configured MSC.
%% @end
check_msc_spc(SPC,GT)->
    MSC=msc_db:get_msc_name({GT,gt}),
    X=msc_ch:check_msc_spc(MSC, SPC, GT),
    io:format("XXXXXX ~p",[X]),
    X.
