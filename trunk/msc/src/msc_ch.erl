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

%%% @doc This is gen_server module that responsible for handling MSCs operations.
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
-export([location_update_request/2, insert_subscriber_data/3, check_msc_spc/3, call_setup/2, receive_PRN/1, send_IAM/2, result_SRI/1]).

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
%%    Parameter = {2, 1, IMSI, LAI} |
%%                {2, 2, IMSI, LAI} |
%%                {2, 3, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom() 
%%    MSC = atom()
%% @doc This function is called when the mobile station is turned on or moves to a new
%% location area or make periodic update to update it's location and state in the VLR and HLR.
%% @end
location_update_request({2, 1, IMSI, LAI}, MSC)->
    io:format("~n~n at LUR in child ~p  ~p ~n~n", [IMSI, MSC]),
    gen_server:cast(MSC, {2, 1, IMSI, LAI, MSC}),
    %imsi_attach({2,1,IMSI,LAI, MSC}),
    ok;

location_update_request({2, 2, IMSI, LAI}, MSC)->
    gen_server:cast(MSC, {2, 2, IMSI, LAI, MSC}),
    %location_update_req({2, 2, IMSI, LAI, MSC}),
    ok;

location_update_request({2, 3, IMSI, LAI}, MSC) ->
    gen_server:cast(MSC, {2, 3, IMSI, LAI}),
    %periodic_location_update({2, 3, IMSI, LAI, MSC}),
    ok;

location_update_request({2, 4, IMSI}, MSC) ->
    gen_server:cast(MSC, {2, 4, IMSI, MSC}),
    %imsi_detach({2, 4, IMSI, MSC}),
    ok.

call_setup({2, 1, IMSI, Bno}, MSC)->
    gen_server:cast(MSC, {3, 1, IMSI, Bno, MSC}),
    ok.
      
receive_PRN({6, 5, IMSI, MSC})->
    gen_server:call(MSC, {IMSI, MSC}).
    
result_SRI({6, 7, MSRN, MSC})->
    gen_server:cast(MSC, {6,7,MSRN,MSC}).

send_IAM({5, 1, Ano, MSRN}, MSC)->
    gen_server:cast(MSC, {5, 1, Ano, MSRN, MSC}).
 
  

%% @spec insert_subscriber_data(IMSI, INFO, SPC) -> Result
%% Result = ok
%% IMSI = atom()
%% SPC = atom()
%% INFO = atom()
%% @doc This function is called when the HLR sends the ISD message
%% to the MSC to insert the subsceiber data in the VLR.
%% @end
insert_subscriber_data(MSC, IMSI, INFO)->
    %insert_sub({6, 2, IMSI, INFO, MSC}).
    gen_server:cast(MSC, {6, 2, IMSI, INFO, MSC}).

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
handle_call({IMSI, MSC}, _From, St) ->

    MSRN = msc_db:get_MSRN(MSC),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": get its MSRN "), %should be msc2
    Msg2 = string:concat(Msg1,atom_to_list(MSRN)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_db:update_MSRN(MSRN),
    msc_db:update_MSRN_sub(MSRN, IMSI),

    Mscname1 = string:concat("MSC ",atom_to_list(MSC)),        
    Msg11= string:concat(Mscname1,": send to HLR MSRN "), %should be msc2
    Msg21 = string:concat(Msg11,atom_to_list(MSRN)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg21)]),
    request_handler:erlang_send(list_to_atom(Msg21)),

    {reply, MSRN, St}.

%% @private
%% @spec handle_cast(Req, List) -> Result
%%    Req = term()
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
    create_record(IMSI,LAI,MSC,VLR),
    
    Sub_MGT = imsi_analysis(IMSI, MSC),

    Sub_MGT_DB = list_to_atom(Sub_MGT),

    SPC = gt_translation(Sub_MGT_DB, MSC),
    
    io:format("Name of SPCCCCCCC ~p~n", [SPC]),

    Reply=hlr:imsiExist(SPC,IMSI),
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": sending update location to HLR with SPC = "),
    Msg2 = string:concat(Msg1,atom_to_list(SPC)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
    
    check_hlr(Reply, {IMSI, VLR, SPC}),
    {noreply, List};

handle_cast({2, 2, IMSI, LAI, MSC}, List) ->
    Reply = msc_db:check_msc_imsi(MSC, IMSI),
    normal_location_update(Reply, MSC, IMSI, LAI),
    {noreply, List};

handle_cast({2, 3, IMSI, LAI}, List) ->
    Reply = msc_db:check_periodic_lai(IMSI, LAI),  
    io:format("periodic update ~p~n", [Reply]),
    {noreply, List};

handle_cast({2, 4, IMSI, MSC}, List) ->
    msc_db:update_subscriber_info(IMSI, off),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": marks the IMSI as detached"),
    io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),
    {noreply, List};


handle_cast({6, 2, IMSI, INFO, MSC}, List) ->
    io:format("~n vvvvvvvv"),
    msc_db:update_subscriber_info({IMSI, INFO}, idle),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": Received subsceiber info from HLR and update its state to idle "),
    io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),
    {noreply, List};

handle_cast({3, 1, IMSI, Bno, MSC}, List) ->
    MSISDN = msc_db:get_MSISDN(IMSI),
    Sub_MSISDN = string:substr(atom_to_list(MSISDN),1, 4),
    io:format("~n~n IMSI of A no is ~p~n",[IMSI]), 
    io:format("~n~nMSISDN of Ano 01001234567890   ~p~n~n", [MSISDN]),
    io:format("~n~nMSISDN of Bno 010001233333   ~p~n~n", [Bno]),

    io:format("~n~n sub imsi ~p ~n~n",[Sub_MSISDN]),
    SPC = msc_db:get_SPC(list_to_atom(Sub_MSISDN)),
    io:format("~n~n SPC ~p ~n~n",[SPC]),

    GT = msc_db:get_GT_MSC(MSC),

    ets:new(my_imsi, [named_table, protected, set, {keypos, 1}]),
    ets:insert(my_imsi, {val, MSISDN}),

    hlr:send_routing_info(Bno, SPC, GT),
    {noreply, List};	 

handle_cast({6,7,MSRN,MSC}, List) ->
 Another_MSC = msc_db:get_msc_name({MSRN, msrn}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": send to another MSC which name is "),
    Msg2 = string:concat(Msg1,atom_to_list(Another_MSC)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    [{_, Ano}] = ets:lookup(my_imsi, val), 
    msc_app:send_IAM({5, 1, Ano, MSRN},Another_MSC),
    {noreply, List};

handle_cast({5, 1, Ano, MSRN, MSC}, List) ->
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": send to MS Ano is "),
    Msg2 = string:concat(Msg1,atom_to_list(Ano)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    IMSI = msc_db:get_IMSI_MSRN(MSRN),
    io:format("IMSI of MSRN ~p~n", [IMSI]),
    ms_app:receiving_setup(IMSI, Ano),
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
    io:format("~n~n GT  ~p~n",[GT]),
    update_location(IMSI, VLR, GT, SPC).


normal_location_update(not_found,MSC,IMSI,LAI)->
    VLR=msc_db:get_VLR(MSC),
    io:format("vlrrrrrr ~p",[VLR]),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": sending inter location update  with new MSC = "),
    Msg2 = string:concat(Msg1,atom_to_list(MSC)),
    Msg3 = string:concat(Msg2,"and new LAI= "),
    Msg4 = string:concat(Msg3,atom_to_list(LAI)),

    io:format("MSg ~p~n ",[list_to_atom(Msg4)]),
    request_handler:erlang_send(list_to_atom(Msg4)),
    

    msc_db:update_subscriber_info({IMSI,LAI,MSC,VLR},newstatus),
    Sub_IMSI=string:substr(atom_to_list(IMSI),6),
    MGT=string:concat("2010",Sub_IMSI),
    Sub_MGT=string:substr(MGT,1,5),
    Sub_MGT_DB=list_to_atom(Sub_MGT),
    SPC=msc_db:get_SPC(Sub_MGT_DB),
    io:format("Nameee of SPC ~p~n", [SPC]),
    Reply=hlr:imsiExist(SPC,IMSI),
    check_hlr(Reply, {IMSI, VLR, SPC});

normal_location_update(_, MSC, IMSI, LAI) ->
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": sending intra location update  with new LAI = "),
    Msg2 = string:concat(Msg1,atom_to_list(LAI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
    
    msc_db:update_subscriber_info(IMSI, LAI).

update_location(IMSI, VLR, GT,SPC)->
    io:format("update_location in child"),
    
    hlr_mgr:update_location({IMSI, VLR, GT},SPC),

    io:format("location updated in child"),
    ok.


create_record(IMSI, LAI, MSC, VLR)->
    Reply = msc_db:get_IMSI(IMSI),
    io:format("~n aaaaat create child ~p~n~n", [Reply]),
    check_imsi_exist(Reply, {IMSI,LAI,MSC,VLR}).

check_imsi_exist(not_found, {IMSI, LAI, MSC, VLR})->
    msc_db:insert_subscriber(IMSI,LAI,MSC,VLR),
    Mscname0 = string:concat("MSC ",atom_to_list(MSC)),        
    Msg0 = string:concat(Mscname0,": insert subscriber info in VLR"),  
    io:format("MSg ~p~n ", [Msg0]),
    request_handler:erlang_send(list_to_atom(Msg0));

check_imsi_exist(_, {IMSI,_LAI, MSC, _VLR}) ->
    msc_db:update_subscriber_info(IMSI, update_idle),
    Mscname0 = string:concat("MSC ",atom_to_list(MSC)),        
    Msg0 = string:concat(Mscname0,": update subscriber info in VLR where this subscriber was in this MSC"),  
    io:format("MSg ~p~n ", [Msg0]),
    request_handler:erlang_send(list_to_atom(Msg0)).
   
imsi_analysis(IMSI, MSC)->
    Sub_IMSI=string:substr(atom_to_list(IMSI),6),
    MGT=string:concat("2010",Sub_IMSI),
    Sub_MGT=string:substr(MGT,1,5),
  
    Mscname0 = string:concat("MSC ",atom_to_list(MSC)),        
    Msg10= string:concat(Mscname0,": IMSI analysis, generating MGT from IMSI, MGT = "),
    Msg20 = string:concat(Msg10, Sub_MGT),    
    io:format("MSg ~p~n ",[Msg20]),
    request_handler:erlang_send(list_to_atom(Msg20)),
    io:format("at imsi analysis ~p~n", [Sub_MGT]),
    Sub_MGT.
    
    
gt_translation(Sub_MGT_DB, MSC)->    
    SPC=msc_db:get_SPC(Sub_MGT_DB), 
    Mscname0 = string:concat("MSC ",atom_to_list(MSC)),        

    Msg100= string:concat(Mscname0,": GT translation, geting SPC of HLR by MGT , SPC = "),
    Msg200 = string:concat(Msg100,atom_to_list(SPC)),    
    io:format("MSg ~p~n ",[Msg200]),
    request_handler:erlang_send(list_to_atom(Msg200)),
    io:format("at gt translation ~p~n", [SPC]),
    SPC.


insert_sub({6,2, IMSI, INFO, MSC})->
    io:format("~n vvvvvvvv"),
    msc_db:update_subscriber_info({IMSI, INFO}, idle),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": Received subsceiber info from HLR and update its state to idle "),
    io:format("MSg ~p~n ",[list_to_atom(Msg1)]),
    request_handler:erlang_send(list_to_atom(Msg1)),
    ok.


    
