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
%%% @author Ahmed Samy <ahm.sam@live.com>
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
%% @doc Builds a msc with the given Name
%% this name is then used to call the module of that msc.
%% @end
start_msc(Name)->
    msc_2nd_sup:start_msc(Name),
 %%   Msg = 'New MSC created with given name ' ++ Name,
 
    Mst = "New MSC created with given name ",
    Namest = atom_to_list(Name),  
    Msgst=string:concat(Mst,Namest),    
    io:format("MSg ~p~n ",[list_to_atom(Msgst)]),
    request_handler:erlang_send(list_to_atom(Msgst)).

%% @spec location_update_request(Parameter) -> Result
%%    Result = ok   
%%    Parameter = {2, 1, IMSI, LAI} |
%%                {2, 2, IMSI, LAI} |
%%                {2, 3, IMSI, LAI} |
%%                {2, 4, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom() 
%% @doc Updates the MS location and state in the VLR and HLR when
%% the MS is turned on or moved to new LA and when executing periodic update.
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

%% @spec insert_subscriber_data(IMSI, INFO, SPC) -> Result
%%     Result = ok
%%     IMSI = atom()
%%     SPC = atom()
%%     INFO = atom()
%% @doc Inserts the subsceiber data given from the HLR in the VLR.
%% @end
insert_subscriber_data(IMSI,INFO,SPC)->
    msc_2nd_sup:insert_subscriber_data(IMSI, INFO, SPC).

%% @spec check_msc_spc(SPC,GT) -> Result
%%    Result = not_found | MSC 
%%    MSC = atom() 
%%    SPC = atom()
%%    GT = atom() 
%% @doc Checks that both the SPC and GT 
%% belong to a configured MSC.
%% @end
check_msc_spc(SPC,GT)->
    Y=msc_2nd_sup:check_msc_spc(SPC,GT),
    io:format("~n MSC_app check_msc_spc:  ~p~n",[Y]),
    Y.


%% @spec call_setup(Param) -> Result
%%    Result = ok
%%    Param = {2, 1, IMSI, LAI, Bno} 
%%    IMSI = atom()
%%    LAI = atom() 
%%    Bno = atom() 
%% @doc Starts the call setup when MSC recieves a request from the MS and send SRI message to HLR.
%% @end
call_setup({2, 1, IMSI, LAI, Bno})-> %{2,1, '602020000000011',lai2, '010001233333'}
    msc_2nd_sup:call_setup({2, 1, IMSI, LAI, Bno}),
    ok.
%% @spec receive_PRN(Param) -> Result
%%    Result = atom()
%%    Param= {6, 5, IMSI, SPC}
%%    IMSI = atom()
%%    SPC = atom() 
%% @doc Assigns MSRN for IMSI.
%% @end
receive_PRN({6, 5, IMSI, SPC})->%IMSI for Bno to assign MSRN
    msc_2nd_sup:receive_PRN({6, 5, IMSI, SPC}).

%% @spec result_SRI(Param) -> Result
%%    Result = atom()
%%    Param= {6, 7, MSRN, SPC}
%%    MSRN = atom()
%%    SPC = atom() 
%% @doc Receives SRIA message from HLR to send IAM message to other MSC.
%% @end
result_SRI({6, 7, MSRN, SPC})->
    msc_2nd_sup:result_SRI({6, 7, MSRN, SPC}).

%% @spec send_IAM(Param, SPC, GT) -> Result
%%    Result = atom()
%%    Param= {5, 1, Ano, MSRN}
%%    MSRN = atom()
%%    Ano = atom() 
%%    SPC = atom()
%%    GT = atom() 
%% @doc Sends IAM message to other MSC.
%% @end
send_IAM({5, 1, Ano, MSRN},SPC,GT)->
    msc_2nd_sup:send_IAM({5, 1, Ano, MSRN},SPC,GT).

%% @spec receiving_alert(Param) -> Result
%%    Result = atom()
%%    Param= {1, 5, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom()  
%% @doc Receives alert message from MS.
%% @end
receiving_alert({1, 5, IMSI, LAI}) ->
    msc_2nd_sup:receive_alert({1, 5, IMSI, LAI}).

%% @spec send_ACM(Param) -> Result
%%    Result = atom()
%%    Param= {5, 2, Ano, SPC}
%%    Ano = atom()
%%    SPC = atom()  
%% @doc Sends ACM message to other MSC.
%% @end
send_ACM({5, 2, Ano, SPC})->
    msc_2nd_sup:send_ACM({5, 2, Ano, SPC}).

%% @spec receive_connect(Param) -> Result
%%    Result = atom()
%%    Param= {1, 6, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom()  
%% @doc Receives connect message from MS to send ANM message to other MSC.
%% @end
receive_connect({1, 6, IMSI, LAI})->
    msc_2nd_sup:receive_connect({1, 6, IMSI, LAI}).
 
%% @spec send_ANM(Param) -> Result
%%    Result = atom()
%%    Param= {5, 3, Ano, SPC}
%%    Ano = atom()
%%    SPC = atom()  
%% @doc Sends ANM message to other MSC.
%% @end
send_ANM({5, 3, Ano, SPC})->
    msc_2nd_sup:receive_ANM({5, 3, Ano, SPC}).


%%--------------- End Call Scenario -----------------------------------------
%% @spec receive_disconnect(Param) -> Result
%%    Result = atom()
%%    Param= {1, 7, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom()  
%% @doc Receives disconnect message from MS to send ISUP REL message to other MSC.
%% @end
receive_disconnect({1, 7, IMSI, LAI})->
    msc_2nd_sup:receive_disconnect({1, 7, IMSI, LAI}).

%% @spec isup_rel(Param) -> Result
%%    Result = atom()
%%    Param= {5, 4, SPC}
%%    SPC = atom() 
%% @doc Receives ISUP REL message from other MSC to reply by ISUP RLC message.
%% @end
isup_rel({5, 4, SPC})->
	msc_2nd_sup:isup_rel({5, 4, SPC}).

%% @spec isup_rlc(Param) -> Result
%%    Result = atom()
%%    Param= {5, 5, SPC}
%%    SPC = atom() 
%% @doc Receives ISUP RLC message from other MSC and send release message to MS.
%% @end
isup_rlc({5, 5, SPC})-> % spc of msc 1
	msc_2nd_sup:isup_rlc({5, 5, SPC}).

%% @spec release_complete(Param) -> Result
%%    Result = atom()
%%    Param= {5, 6, IMSI, LAI}
%%    IMSI = atom() 
%%    LAI = atom() 
%% @doc Receives Release complete message from MS.
%% @end
release_complete({5, 6, IMSI, LAI})-> %at msc1
	msc_2nd_sup:release_complete({5, 6, IMSI, LAI}).

%% @spec release_msg(Param) -> Result
%%    Result = atom()
%%    Param= {5, 7, IMSI, LAI}
%%    IMSI = atom() 
%%    LAI = atom() 
%% @doc Receives Release message from MS.
%% @end
release_msg({5, 7, IMSI, LAI})-> % to msc2
	msc_2nd_sup:release_msg({5, 7, IMSI, LAI}).


	
