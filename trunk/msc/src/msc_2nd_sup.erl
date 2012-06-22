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
%%% This supervisor is responsible of starting any MSC 
%%% dynamically.
%%% @copyright 2012 ITI Egypt.
%%% @author Esraa Adel <esraa.elmelegy@hotmail.com>
%%% @author Sherif Ashraf <sherif_ashraf89@hotmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(msc_2nd_sup).
-behaviour(supervisor).

%%% Start/Stop exports
-export([start_link/0]).

%%% Internal exports
-export([init/1]).

%%% External exports
-export([start_msc/1, location_update_request/1, insert_subscriber_data/3,check_msc_spc/2]).

-compile([export_all]).
%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

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
%%%--------------------------------------------------------------------------
%% @spec start_msc(Name) -> Result
%%    Result = {ok, Pid} 
%%    Pid = pid()  
%%    Name = atom() 
%% @doc This function is called to build a msc with the given Name
%% this name is then used to call the module of that msc.
%% @end
start_msc(Name)->
    supervisor:start_child(?MODULE, [Name]).

%% @spec location_update_request(Parameter) -> Result
%%    Result = ok   
%%    Parameter = {2,1,IMSI,LAI} |
%%                {2, 2, IMSI, LAI} |
%%                {2, 3, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom() 
%% @doc This function is called when the mobile station is turned on or moves to a new
%% location area or make periodic update to update it's location and state in the VLR and HLR.
%% @end
location_update_request({2,1,IMSI, LAI})->
    MSC = msc_db:get_msc_name({LAI,lai}),
    io:format("~n~n at 2nd sup ~p~n~n",[MSC]),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": imsi attach request from "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
    msc_ch:location_update_request({2,1,IMSI, LAI}, MSC);

    
location_update_request({2,2,IMSI, LAI})->
    MSC = msc_db:get_msc_name({LAI,lai}),
    msc_ch:location_update_request({2,2,IMSI, LAI}, MSC),
    
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": normal location update from  "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2));

location_update_request({2, 3, IMSI, LAI}) ->
    MSC = msc_db:get_msc_name({LAI,lai}),
    msc_ch:location_update_request({2, 3, IMSI, LAI}, MSC),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": periodic location update from  "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2));

location_update_request({2, 4, IMSI, LAI}) ->
    MSC = msc_db:get_msc_name({LAI,lai}),
    msc_ch:location_update_request({2, 4, IMSI}, MSC),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": IMSI detach request from  "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)).

    
%% @spec insert_subscriber_data(IMSI,INFO,SPC) -> Result
%%    Result = ok   
%%    IMSI = atom()
%%    SPC = atom()
%%    INFO = atom() 
%% @doc This function is called when the HLR sends the ISD message
%% to the MSC to insert the subsceiber data in the VLR.
%% @end
insert_subscriber_data(IMSI, INFO,SPC )->
    MSC=msc_db:get_msc_name({SPC,spc}),
    msc_ch:insert_subscriber_data(MSC, IMSI, INFO).

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
    io:format("2nd_sup check_msc_spc : ~p ~n",[X]),
    X.
call_setup({2, 1, IMSI, LAI, Bno})->
    MSC = msc_db:get_msc_name({LAI,lai}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": received call setup message from IMSI  "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_ch:call_setup({2, 1, IMSI, Bno}, MSC).

    
receive_PRN({6, 5, IMSI, SPC})->
    MSC = msc_db:get_msc_name({SPC,spc}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": received PRN message from HLR with IMSI "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
    
    msc_ch:receive_PRN({6, 5, IMSI, MSC}).


result_SRI({6, 7, MSRN, SPC})->
    MSC=msc_db:get_msc_name({SPC,spc}),
    
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": HLR answer with MSRN "),
    Msg2 = string:concat(Msg1,atom_to_list(MSRN)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
    msc_ch:result_SRI({6, 7, MSRN, MSC}).


send_IAM({5, 1, Ano, MSRN},Another_MSC)->
    
    Mscname = string:concat("MSC ",atom_to_list(Another_MSC)),        
    Msg1= string:concat(Mscname,": recived IAM message  "),
    Msg2 = string:concat(Msg1,atom_to_list(MSRN)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_ch:send_IAM({5, 1, Ano, MSRN}, Another_MSC).
