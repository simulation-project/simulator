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
%%% This application has all the APIs to communicate with the MSC. 
%%% @copyright 2012 ITI Egypt.
%%% @author Esraa Adel <esraa.elmelegy@hotmail.com>
%%% @author Sherif Ashraf <sherif_ashraf89@hotmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end

-module(msc_app).
-behaviour(application).

%%% Include files

%%% Start/Stop exports
-export([start/2, stop/1]).

%%% External exports
-export([ start_msc/1, location_update_request/1, insert_subscriber_data/3, check_msc_spc/2, call_setup/1,
          receive_disconnect/1, isup_rel/1, isup_rlc/1, release_complete/1, release_msg/1]).

-compile([export_all]).
%%% Macros

%%% Data types

%%%-----------------------------------------------------------------------------
%%% Start/Stop exports
%%%-----------------------------------------------------------------------------
%% @spec start(Type, StartArgs) -> Result
%%    Result = {ok, Pid} |
%%             {ok, Pid, State} |
%%             {error, Reason}
%%    Pid = pid()  
%%    State = term() 
%%    Reason = term() 
%%
%% @doc Starts the application.
%% @end
start(_Type, _StartArgs) ->
    code:add_path("test/stub"),
    msc_1st_sup:start_link().

%% @spec stop(St) -> ok
%%    St = term()
%%
%% @doc Stops the application.
%% @end
stop(_St) ->
    ok.

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
start_msc(Name)->
    msc_2nd_sup:start_msc(Name),
 %%   Msg = 'New MSC created with given name ' ++ Name,
 
    Mst = "New MSC created with given name ",
    Namest = atom_to_list(Name),  
    Msgst=string:concat(Mst,Namest),    
    io:format("MSg ~p~n ",[list_to_atom(Msgst)]),

	M = string:concat(Msgst, "\n"),
	send_to_log(M),

    request_handler:erlang_send(list_to_atom(Msgst)).

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


location_update_request({2, 1, IMSI, LAI})->
    msc_2nd_sup:location_update_request({2, 1, IMSI, LAI}),
    ok;

location_update_request({2, 2, IMSI, LAI}) ->
    msc_2nd_sup:location_update_request({2, 2, IMSI, LAI}),
    ok;

location_update_request({2, 3, IMSI, LAI})->
    io:format("PPPPPPPPPPEriodic update ~n~n"),
    msc_2nd_sup:location_update_request({2, 3, IMSI, LAI}),
    ok;

location_update_request({2, 4, IMSI, LAI}) ->
    msc_2nd_sup:location_update_request({2,4, IMSI, LAI}),
    ok.

%% @spec insert_subscriber_data(IMSI,INFO,SPC) -> Result
%% Result = ok
%% IMSI = atom()
%% SPC = atom()
%% INFO = atom()
%% @doc This function is called when the HLR sends the ISD message
%% to the MSC to insert the subsceiber data in the VLR.
%% @end
insert_subscriber_data(IMSI,INFO,SPC)->
    msc_2nd_sup:insert_subscriber_data(IMSI, INFO, SPC).

%% @spec check_msc_spc(SPC,GT) -> Result
%%    Result = not_found | MSC 
%%    MSC = atom() 
%%    SPC = atom()
%%    GT = atom() 
%% @doc This function is called to check that both the SPC and GT 
%% belong to a configured MSC.
%% @end
check_msc_spc(SPC,GT)->
    Y=msc_2nd_sup:check_msc_spc(SPC,GT),
    io:format("~n MSC_app check_msc_spc:  ~p~n",[Y]),
    Y.


call_setup({2, 1, IMSI, LAI, Bno})-> %{2,1, '602020000000011',lai2, '010001233333'}
    msc_2nd_sup:call_setup({2, 1, IMSI, LAI, Bno}),
    ok.

receive_PRN({6, 5, IMSI, SPC})->%IMSI for Bno to assign MSRN
    msc_2nd_sup:receive_PRN({6, 5, IMSI, SPC}).

result_SRI({6, 7, MSRN, SPC})->
    msc_2nd_sup:result_SRI({6, 7, MSRN, SPC}).

send_IAM({5, 1, Ano, MSRN},SPC,GT)->
    msc_2nd_sup:send_IAM({5, 1, Ano, MSRN},SPC,GT).

receiving_alert({1,5,IMSI,LAI}) ->
    msc_2nd_sup:receive_alert({1, 5, IMSI, LAI}).

send_ACM({5, 2, Ano, SPC})->
    msc_2nd_sup:send_ACM({5,2,Ano,SPC}).

receive_connect({1, 6, IMSI, LAI})->
    msc_2nd_sup:receive_connect({1,6,IMSI,LAI}).
 
send_ANM({5, 3, Ano, SPC})->
    msc_2nd_sup:receive_ANM({5,3,Ano,SPC}).

%%--------------- End Call Scenario -----------------------------------------
receive_disconnect({1, 7, IMSI, LAI})->
    msc_2nd_sup:receive_disconnect({1, 7, IMSI, LAI}).

isup_rel({5, 4, SPC})->
	msc_2nd_sup:isup_rel({5, 4, SPC}).

isup_rlc({5, 5, SPC})-> % spc of msc 1
	msc_2nd_sup:isup_rlc({5, 5, SPC}).

release_complete({5, 6, IMSI, LAI})-> %at msc1
	msc_2nd_sup:release_complete({5, 6, IMSI, LAI}).

release_msg({5, 7, IMSI, LAI})-> % to msc2
	msc_2nd_sup:release_msg({5, 7, IMSI, LAI}).


send_to_log(Msg)->
	{ok, Path} = application:get_env(msc, log_file),
	disk_log:open([{name, msc}, {file, Path},{format, external},{type, halt}]),
	disk_log:blog(msc, list_to_binary(Msg)),
	disk_log:close(msc).
	
