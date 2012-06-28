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
%%% @author Ahmed Samy <ahm.sam@live.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(msc_2nd_sup).
-behaviour(supervisor).

%%% Start/Stop exports
-export([start_link/0]).

%%% Internal exports
-export([init/1]).

%%% External exports
-export([start_msc/1, location_update_request/1, insert_subscriber_data/3,check_msc_spc/2,
	receive_disconnect/1, isup_rel/1, isup_rlc/1, release_complete/1, release_msg/1]).

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
%% @doc Builds a msc with the given Name
%% this name is then used to call the module of that msc.
%% @end
start_msc(Name)->
    supervisor:start_child(?MODULE, [Name]).

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

%% @spec insert_subscriber_data(IMSI, INFO, SPC) -> Result
%%     Result = ok
%%     IMSI = atom()
%%     SPC = atom()
%%     INFO = atom()
%% @doc Inserts the subsceiber data given from the HLR in the VLR.
%% @end
insert_subscriber_data(IMSI, INFO,SPC )->
    MSC=msc_db:get_msc_name({SPC,spc}),
    msc_ch:insert_subscriber_data(MSC, IMSI, INFO).

%% @spec check_msc_spc(SPC,GT) -> Result
%%    Result = not_found | MSC 
%%    MSC = atom() 
%%    SPC = atom()
%%    GT = atom() 
%% @doc Checks that both the SPC and GT 
%% belong to a configured MSC.
%% @end
check_msc_spc(SPC,GT)->
    MSC=msc_db:get_msc_name({GT,gt}),
    X=msc_ch:check_msc_spc(MSC, SPC, GT),
    io:format("2nd_sup check_msc_spc : ~p ~n",[X]),
    X.

%% @spec call_setup(Param) -> Result
%%    Result = ok
%%    Param = {2, 1, IMSI, LAI, Bno} 
%%    IMSI = atom()
%%    LAI = atom() 
%%    Bno = atom() 
%% @doc Starts the call setup when MSC recieves a request from the MS and send SRI message to HLR.
%% @end
call_setup({2, 1, IMSI, LAI, Bno})->
    MSC = msc_db:get_msc_name({LAI,lai}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": received call setup message from IMSI  "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_ch:call_setup({2, 1, IMSI, Bno}, MSC).

%% @spec receive_PRN(Param) -> Result
%%    Result = atom()
%%    Param= {6, 5, IMSI, SPC}
%%    IMSI = atom()
%%    SPC = atom() 
%% @doc Assigns MSRN for IMSI.
%% @end
receive_PRN({6, 5, IMSI, SPC})->
    MSC = msc_db:get_msc_name({SPC,spc}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": received PRN message from HLR with IMSI "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
    
    msc_ch:receive_PRN({6, 5, IMSI, MSC}).

%% @spec result_SRI(Param) -> Result
%%    Result = atom()
%%    Param= {6, 7, MSRN, SPC}
%%    MSRN = atom()
%%    SPC = atom() 
%% @doc Receives SRIA message from HLR to send IAM message to other MSC.
%% @end
result_SRI({6, 7, MSRN, SPC})->
    MSC=msc_db:get_msc_name({SPC,spc}),
    
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": HLR answer with MSRN "),
    Msg2 = string:concat(Msg1,atom_to_list(MSRN)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
    msc_ch:result_SRI({6, 7, MSRN, MSC}).

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
     Another_MSC = msc_db:get_msc_name({SPC,spc}),

    Mscname = string:concat("MSC ",atom_to_list(Another_MSC)),        
    Msg1= string:concat(Mscname,": recived IAM message  "),
    Msg2 = string:concat(Msg1,atom_to_list(MSRN)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_ch:send_IAM({5, 1, Ano, MSRN}, Another_MSC,GT).

%% @spec receive_alert(Param) -> Result
%%    Result = atom()
%%    Param= {1, 5, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom()  
%% @doc Receives alert message from MS.
%% @end
receive_alert({1, 5, IMSI, LAI})->
    
    MSC = msc_db:get_msc_name({LAI,lai}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": received alert_ack message from IMSI  "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_ch:receive_alert({1, 5, IMSI}, MSC).

%% @spec send_ACM(Param) -> Result
%%    Result = atom()
%%    Param= {5, 2, Ano, SPC}
%%    Ano = atom()
%%    SPC = atom()  
%% @doc Sends ACM message to other MSC.
%% @end
send_ACM({5,2,Ano,SPC})->
     MSC = msc_db:get_msc_name({SPC,spc}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": receiving ACM message  "   ),
    io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),

    msc_ch:receive_ACM({5,2,Ano,MSC}).
    
%% @spec receive_connect(Param) -> Result
%%    Result = atom()
%%    Param= {1, 6, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom()  
%% @doc Receives connect message from MS to send ANM message to other MSC.
%% @end
receive_connect({1,6,IMSI,LAI})->
    
    MSC = msc_db:get_msc_name({LAI,lai}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": Bno send connect message to MSC "),
    Msg2 = string:concat(Msg1,atom_to_list(MSC )),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_ch:receive_connect   ({1, 6, IMSI}, MSC).

%% @spec receive_ANM(Param) -> Result
%%    Result = atom()
%%    Param= {5, 3, Ano, SPC}
%%    Ano = atom()
%%    SPC = atom()  
%% @doc Sends ANM message to other MSC.
%% @end
receive_ANM({5, 3, Ano, SPC})->
    
    MSC = msc_db:get_msc_name({SPC,spc}),
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": receiving ANM  message "),
    io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),

    msc_ch:receive_ANM({5,3,Ano,MSC}).
    
%% ------------------- End Call ---------------------------------------
%% @spec receive_disconnect(Param) -> Result
%%    Result = atom()
%%    Param= {1, 7, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom()  
%% @doc Receives disconnect message from MS to send ISUP REL message to other MSC.
%% @end
receive_disconnect({1, 7, IMSI, LAI})->
    MSC = msc_db:get_msc_name({LAI,lai}),
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": Ano send disconnect message to MSC "),
    Msg2 = string:concat(Msg1,atom_to_list(MSC )),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
	
    msc_ch:receive_disconnect({1, 7, IMSI}, MSC).

%% @spec isup_rel(Param) -> Result
%%    Result = atom()
%%    Param= {5, 4, SPC}
%%    SPC = atom() 
%% @doc Receives ISUP REL message from other MSC to reply by ISUP RLC message.
%% @end
isup_rel({5, 4, SPC})->
    MSC=msc_db:get_msc_name({SPC,spc}),
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": Receive ISUP REL message from another MSC "),
    io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),
    msc_ch:isup_rel({5, 4, MSC}).

%% @spec isup_rlc(Param) -> Result
%%    Result = atom()
%%    Param= {5, 5, SPC}
%%    SPC = atom() 
%% @doc Receives ISUP RLC message from other MSC and send release message to MS.
%% @end
isup_rlc({5, 5, SPC})->

    MSC=msc_db:get_msc_name({SPC,spc}),
    
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": Receive ISUP RLC message from another MSC "),
    io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),
    msc_ch:isup_rlc({5, 5, MSC}).

%% @spec release_complete(Param) -> Result
%%    Result = atom()
%%    Param= {5, 6, IMSI, LAI}
%%    IMSI = atom() 
%%    LAI = atom() 
%% @doc Receives Release complete message from MS.
%% @end
release_complete({5, 6, IMSI, LAI})->
    MSC = msc_db:get_msc_name({LAI,lai}),
    
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": Received Release Complete message from Ano "),
	io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),
    
    msc_ch:release_complete({5, 6, IMSI, LAI}, MSC).

%% @spec release_msg(Param) -> Result
%%    Result = atom()
%%    Param= {5, 7, IMSI, LAI}
%%    IMSI = atom() 
%%    LAI = atom() 
%% @doc Receives Release message from MS.
%% @end
release_msg({5, 7, IMSI, LAI})->
    MSC = msc_db:get_msc_name({LAI,lai}),
    
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": receive from Bno Release message"),
    io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),

    msc_ch:release_msg({5, 7, IMSI, LAI}, MSC).


