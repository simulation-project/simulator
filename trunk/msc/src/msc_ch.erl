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
%%% @author Ahmed Samy <ahm.sam@live.com>
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
-export([location_update_request/2, insert_subscriber_data/3, check_msc_spc/3, call_setup/2, receive_PRN/1, send_IAM/3, result_SRI/1,
	receive_alert/2, receive_connect/2, receive_ANM/1, receive_ACM/1, receive_disconnect/2, isup_rel/1, isup_rlc/1,
        release_complete/2, release_msg/2]).
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
    ets:new(bno, [named_table, protected, set, {keypos, 1}]),
    ets:new(imsi_bno, [named_table, protected, set, {keypos, 1}]),
    ets:new(my_imsi, [named_table, protected, set, {keypos, 1}]),
    ets:new(msc_2, [named_table, protected, set, {keypos, 1}]),
    ets:new(my_gt, [named_table, protected, set, {keypos, 1}]),
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

%% @spec location_update_request(Parameter, MSC)-> Result
%%    Result = ok   
%%    Parameter = {2, 1, IMSI, LAI} |
%%                {2, 2, IMSI, LAI} |
%%                {2, 3, IMSI, LAI} |
%%                {2, 4, IMSI, LAI}
%%    IMSI = atom()
%%    LAI = atom() 
%%    MSC = atom()
%% @doc Updates the MS location and state in the VLR and HLR when
%% the MS is turned on or moved to new LA and when executing periodic update.
%% @end
location_update_request({2, 1, IMSI, LAI}, MSC)->
    io:format("~n~n at LUR in child ~p  ~p ~p ~n~n", [IMSI, MSC,LAI]),
    gen_server:cast(MSC, {2, 1, IMSI, LAI, MSC}),
    ok;

location_update_request({2, 2, IMSI, LAI}, MSC)->
    gen_server:cast(MSC, {2, 2, IMSI, LAI, MSC}),
    ok;

location_update_request({2, 3, IMSI, LAI}, MSC) ->
    gen_server:cast(MSC, {2, 3, IMSI, LAI}),
    ok;

location_update_request({2, 4, IMSI}, MSC) ->
    gen_server:cast(MSC, {2, 4, IMSI, MSC}),
    ok.

%% @spec call_setup(Param, MSC) -> Result
%%    Result = ok
%%    Param = {2, 1, IMSI, Bno} 
%%    IMSI = atom()
%%    MSC = atom() 
%%    Bno = atom() 
%% @doc Starts the call setup when MSC recieves a request from the MS and send SRI message to HLR.
%% @end
call_setup({2, 1, IMSI, Bno}, MSC)->
    gen_server:cast(MSC, {3, 1, IMSI, Bno, MSC}),
    ok.
   
%% @spec receive_PRN(Param) -> Result
%%    Result = atom()
%%    Param= {6, 5, IMSI, MSC}
%%    IMSI = atom()
%%    MSC = atom() 
%% @doc Assigns MSRN for IMSI.
%% @end   
receive_PRN({6, 5, IMSI, MSC})->
    gen_server:call(MSC, {IMSI, MSC}).
    
%% @spec result_SRI(Param) -> Result
%%    Result = atom()
%%    Param= {6, 7, MSRN, MSC}
%%    MSRN = atom()
%%    MSC = atom() 
%% @doc Receives SRIA message from HLR to send IAM message to other MSC.
%% @end
result_SRI({6, 7, MSRN, MSC})->
    gen_server:cast(MSC, {6, 7, MSRN, MSC}).

%% @spec send_IAM(Param, MSC, GT) -> Result
%%    Result = atom()
%%    Param= {5, 1, Ano, MSRN}
%%    MSRN = atom()
%%    Ano = atom() 
%%    MSC = atom()
%%    GT = atom() 
%% @doc Sends IAM message to other MSC.
%% @end
send_IAM({5, 1, Ano, MSRN}, MSC, GT)->
    gen_server:cast(MSC, {5, 1, Ano, MSRN, MSC,GT}).
 
%% @spec receive_alert(Param, MSC) -> Result
%%    Result = atom()
%%    Param= {1, 5, IMSI}
%%    IMSI = atom()
%%    MSC = atom()  
%% @doc Receives alert message from MS.
%% @end 
receive_alert({1, 5, IMSI}, MSC)->
    gen_server:cast(MSC, {1, 5, IMSI, MSC}).

%% @spec receive_ACM(Param) -> Result
%%    Result = atom()
%%    Param= {5, 2, Ano, MSC}
%%    Ano = atom()
%%    MSC = atom()  
%% @doc Sends ACM message to other MSC.
%% @end
receive_ACM({5, 2, Ano, MSC})->
    gen_server:cast(MSC, {5, 2, Ano, MSC}).

%% @spec receive_connect(Param, MSC) -> Result
%%    Result = atom()
%%    Param= {1, 6, IMSI}
%%    IMSI = atom()
%%    MSC = atom()  
%% @doc Receives connect message from MS to send ANM message to other MSC.
%% @end
receive_connect({1, 6, IMSI}, MSC)->
    gen_server:cast(MSC, {1, 6,IMSI, MSC}).

%% @spec receive_ANM(Param) -> Result
%%    Result = atom()
%%    Param= {5, 3, Ano, MSC}
%%    Ano = atom()
%%    MSC = atom()  
%% @doc Sends ANM message to other MSC.
%% @end
receive_ANM({5, 3, Ano, MSC})->
      gen_server:cast(MSC, {5, 3, Ano, MSC}).


%% **********************************************************************
%% @spec receive_disconnect(Param, MSC) -> Result
%%    Result = atom()
%%    Param= {1, 7, IMSI}
%%    IMSI = atom()
%%    MSC = atom()  
%% @doc Receives disconnect message from MS to send ISUP REL message to other MSC.
%% @end
receive_disconnect({1, 7, IMSI}, MSC)->
    gen_server:cast(MSC, {1, 7,IMSI, MSC}).

%% @spec isup_rel(Param) -> Result
%%    Result = atom()
%%    Param= {5, 4, MSC}
%%    MSC = atom() 
%% @doc Receives ISUP REL message from other MSC to reply by ISUP RLC message.
%% @end
isup_rel({5, 4, MSC})->
    gen_server:cast(MSC, {5, 4, MSC}).

%% @spec isup_rlc(Param) -> Result
%%    Result = atom()
%%    Param= {5, 5, MSC}
%%    MSC = atom() 
%% @doc Receives ISUP RLC message from other MSC and send release message to MS.
%% @end
isup_rlc({5, 5, MSC})->
    gen_server:cast(MSC, {5, 5, MSC}).

%% @spec release_complete(Param, MSC) -> Result
%%    Result = atom()
%%    Param= {5, 6, IMSI, LAI}
%%    IMSI = atom() 
%%    LAI = atom() 
%%    MSC = atom()
%% @doc Receives Release complete message from MS.
%% @end
release_complete({5, 6, IMSI, LAI}, MSC)->
    gen_server:cast(MSC, {5, 6, IMSI, LAI, MSC}).

%% @spec release_msg(Param, MSC) -> Result
%%    Result = atom()
%%    Param= {5, 7, IMSI, LAI}
%%    IMSI = atom() 
%%    LAI = atom() 
%%    MSC = atom()
%% @doc Receives Release message from MS.
%% @end
release_msg({5, 7, IMSI, LAI}, MSC)->
    gen_server:cast(MSC, {5, 7, IMSI, LAI, MSC}).


%% **********************************************************************
%% @spec insert_subscriber_data(IMSI, INFO, SPC) -> Result
%%     Result = ok
%%     IMSI = atom()
%%     SPC = atom()
%%     INFO = atom()
%% @doc Inserts the subsceiber data given from the HLR in the VLR.
%% @end
insert_subscriber_data(MSC, IMSI, INFO)->
    %insert_sub({6, 2, IMSI, INFO, MSC}).
    gen_server:cast(MSC, {6, 2, IMSI, INFO, MSC}).

%% @spec check_msc_spc(MSC, SPC, GT) -> Result
%%    Result = not_found | MSC 
%%    MSC = atom() 
%%    SPC = atom()
%%    GT = atom() 
%% @doc Checks that both the SPC and GT 
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

%% ************ save IMSI of Bno ***************************
    %ets:new(imsi_bno, [named_table, protected, set, {keypos, 1}]),
    ets:insert(imsi_bno, {val, IMSI}),
%% *********************************************************

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
%%    Req = {2, 1, IMSI, LAI, MSC} |
%%          {2, 2, IMSI, LAI, MSC} |
%%          {2, 3, IMSI, LAI} |
%%          {2, 4, IMSI, MSC} |
%%          {6, 2, IMSI, INFO, MSC} |
%%          {3, 1, IMSI, Bno, MSC} |
%%          {6, 7, MSRN, MSC} |
%%          {5, 1, Ano, MSRN, MSC, GT} |
%%          {1, 5, IMSI, MSC} | 
%%          {5, 2, Ano, MSC} |
%%          {1, 6, IMSI, MSC} |
%%          {5, 3, Ano, MSC} |
%%          {1, 7, IMSI, MSC} |
%%          {5, 4, MSC} |
%%          {5, 5, MSC} |
%%          {5, 6, IMSI, LAI, MSC} |
%%          {5, 7, IMSI, LAI, MSC}
%%    Result = {noreply, NewSt} |
%%             {stop, Reason, NewSt}
%%    IMSI = atom()
%%    LAI = atom()
%%    MSC = atom()
%%    INFO = atom()
%%    Bno = atom()
%%    MSRN = atom()
%%    Ano = atom()
%%    GT = atom()
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
    io:format("~n~n aaaaat handle cast ~n"),
    VLR=msc_db:get_VLR(MSC),
    create_record(IMSI,LAI,MSC,VLR),
    
    %Sub_MGT = imsi_analysis(IMSI, MSC),
    Number_Series = imsi_analysis(IMSI, MSC),

    Number_Series_DB = list_to_atom(Number_Series),

    SPC =msc_db:get_SPC(Number_Series_DB,MSC), 
    
    io:format("Name of SPCCCCCCC ~p~n", [SPC]),

    Reply = hlr_mgr:imsiExist(SPC,IMSI),
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

%% ********************* update MS-A to be active ****************************
    msc_db:update_status(IMSI),
    %ets:new(bno, [named_table, protected, set, {keypos, 1}]),
    ets:insert(bno, {val, Bno}),
%% ***************************************************************************

    MSISDN = msc_db:get_MSISDN(IMSI),

    %Sub_BNO = string:substr(atom_to_list(Bno),1, 5),
    
    io:format("~n~n IMSI of A no is ~p~n",[IMSI]), 
    io:format("~n~nMSISDN of Ano 01001234567890   ~p~n~n", [MSISDN]),
    io:format("~n~nMSISDN of Bno 010001233333   ~p~n~n", [Bno]),


    %io:format("~n~n sub imsi ~p ~n~n",[Sub_BNO]),
    
    NUMB_SER = get_number_series(bno,Bno,MSC),
    io:format("~n~n sub imsi ~p ~n~n",[NUMB_SER]),

    SPC = msc_db:get_SPC_MSISDN(list_to_atom(NUMB_SER), MSC),
    io:format("~n~n SPC ~p ~n~n",[SPC]),

    GT = msc_db:get_GT_MSC(MSC),
    %ets:new(my_imsi, [named_table, protected, set, {keypos, 1}]),
    ets:insert(my_imsi, {val, MSISDN}),
    hlr_mgr:send_routing_info(Bno, SPC, GT),
    {noreply, List};	 

handle_cast({6, 7, MSRN, MSC}, List) ->

   %SUBMSRN = string:substr(atom_to_list(MSRN),1, 6),

   NUMB_SER_msrn = get_number_series(bno,MSRN,MSC),


    SPC2 = msc_db:get_MSRN_SPC(NUMB_SER_msrn, MSC),
    io:format("SUBMSRN===== ~p ~n~n",[NUMB_SER_msrn]),

   % SPC2 = spc2,
    
%%*************************
    %ets:new(msc_2, [named_table, protected, set, {keypos, 1}]),
    ets:insert(msc_2, {val, SPC2}),
%%*************************

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": send to another MSC which SPC is "),
    Msg2 = string:concat(Msg1,atom_to_list(SPC2)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    [{_, Ano}] = ets:lookup(my_imsi, val), 
    GT = msc_db:get_GT_MSC(MSC),

    msc_app:send_IAM({5, 1, Ano, MSRN},SPC2,GT),
    {noreply, List};

handle_cast({5, 1, Ano, MSRN, MSC,GT}, List) ->

    %ets:new(my_gt, [named_table, protected, set, {keypos, 1}]),
    ets:insert(my_gt, {val, GT}),

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": send to MS Ano is "),
    Msg2 = string:concat(Msg1,atom_to_list(Ano)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    IMSI = msc_db:get_IMSI_MSRN(MSRN),
    io:format("IMSI of MSRN ~p~n", [IMSI]),
    %New_Ano = list_to_atom(Ano),
    ms_app:receiving_setup(IMSI, Ano),
    {noreply, List};

handle_cast({1, 5, IMSI, MSC}, List) ->
   
    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": update status to be active of IMSI "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),
    _R = msc_db:update_status(IMSI),
    
    [{_, GT}] = ets:lookup(my_gt, val), 
    SPC = msc_db:get_SPC_GT(GT),
    

    [{_, Ano}] = ets:lookup(my_imsi, val),

    msc_app:send_ACM({5,2,Ano,SPC}),

    {noreply, List}; 
   
handle_cast({5, 2, Ano, _MSC},List) ->
    
    IMSI = msc_db:get_IMSI_from_no(Ano),
     ms_app:receiving_alert(IMSI),
    {noreply, List}; 

handle_cast({1, 6, _IMSI, _MSC},List) ->
    
    [{_, GT}] = ets:lookup(my_gt, val), 
    SPC = msc_db:get_SPC_GT(GT),

    [{_, Ano}] = ets:lookup(my_imsi, val),
    msc_app:send_ANM({5, 3, Ano, SPC}),
    {noreply, List};
   
handle_cast({5, 3, Ano, _MSC}, List) ->
    IMSI = msc_db:get_IMSI_from_no(Ano),
     ms_app:receiving_answer(IMSI),   
    _R = msc_db:update_status(IMSI),

    {noreply, List};
%% *************************** End Call **********************
handle_cast({1, 7, _IMSI, _MSC}, List) ->
    [{_, SPC2}] = ets:lookup(msc_2, val), 
    msc_app:isup_rel({5, 4, SPC2}), % msc1 send ISUP REL msg to msc2
    {noreply, List};

handle_cast({5, 4, _MSC}, List) -> % at msc2 (msc sned ISUP RLC to msc1)
    
    [{_, GT}] = ets:lookup(my_gt, val), 
    SPC = msc_db:get_SPC_GT(GT), %SPC for msc1
    msc_app:isup_rlc({5, 5, SPC}),		

    [{_, IMSI_Bno}] = ets:lookup(imsi_bno, val), 
    io:format("~n~n IMSI of Bno ~p~n~n", [IMSI_Bno]),
    ms_app:send_disconnect(IMSI_Bno),
    {noreply, List};

handle_cast({5, 5, _MSC}, List) ->
    [{_, Ano}] = ets:lookup(my_imsi, val),
    IMSI = msc_db:get_IMSI_from_no(Ano),
    ms_app:release_msg(IMSI), % send to Ano 
    {noreply, List};

handle_cast({5, 6, IMSI, _LAI, MSC}, List) ->

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": update status to be idle of Ano with IMSI "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_db:update_subscriber_info(IMSI, update_idle), % set status to MS 1 to be idle
    {noreply, List};

handle_cast({5, 7, IMSI, _LAI, MSC}, List) ->% to msc2

    Mscname = string:concat("MSC ",atom_to_list(MSC)),        
    Msg1= string:concat(Mscname,": update status to be idle of Bno with IMSI "),
    Msg2 = string:concat(Msg1,atom_to_list(IMSI)),    
    io:format("MSg ~p~n ",[list_to_atom(Msg2)]),
    request_handler:erlang_send(list_to_atom(Msg2)),

    msc_db:update_subscriber_info(IMSI, update_idle), % set status to MS 2 to be idle
    MSRN = msc_db:get_MSRN_IMSI(IMSI),
    msc_db:release_MSRN(IMSI),
    msc_db:reset_MSRN(MSRN),
    ms_app:release_complete(IMSI),
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
    %Sub_IMSI=string:substr(atom_to_list(IMSI),6),
    %MGT=string:concat("2010",Sub_IMSI),
    %Sub_MGT=string:substr(MGT,1,5),

    %Sub_MGT_DB=list_to_atom(Sub_MGT),
    %SPC=msc_db:get_SPC(Sub_MGT_DB, MSC),
    Number_Series = imsi_analysis(IMSI, MSC),

    Number_Series_DB = list_to_atom(Number_Series),

    SPC =msc_db:get_SPC(Number_Series_DB,MSC), 
    io:format("Nameee of SPC ~p~n", [SPC]),
    Reply=hlr_mgr:imsiExist(SPC,IMSI),
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
io:format("MGTTTTT ~p ~n",[MGT]),
    Matched_Number_series=get_number_series(gt,MGT,MSC),
    Matched_Number_series.
   % Sub_MGT=string:substr(MGT,1,5),
  
   % Mscname0 = string:concat("MSC ",atom_to_list(MSC)),        
   % Msg10= string:concat(Mscname0,": IMSI analysis, generating MGT from IMSI, MGT = "),
   % Msg20 = string:concat(Msg10, Sub_MGT),    
   % io:format("MSg ~p~n ",[Msg20]),
   % request_handler:erlang_send(list_to_atom(Msg20)),
   % io:format("at imsi analysis ~p~n", [Sub_MGT]),
   % Sub_MGT.

        
gt_translation(Sub_MGT_DB, MSC)->    
   SPC=msc_db:get_SPC(Sub_MGT_DB, MSC), 
    Mscname0 = string:concat("MSC ",atom_to_list(MSC)),        

    Msg100= string:concat(Mscname0,": GT translation, geting SPC of HLR by MGT , SPC = "),
    Msg200 = string:concat(Msg100,atom_to_list(SPC)),    
    io:format("MSg ~p~n ",[Msg200]),
    request_handler:erlang_send(list_to_atom(Msg200)),
    io:format("at gt translation ~p~n", [SPC]),
    SPC.

  
get_number_series(gt,MGT,MSC)->
    Number_series=msc_db:get_number_series(gt,MSC),
    io:format("number_series is ~p",[Number_series]),
    Matched_Number_Series = evaluate_number_series(MGT,Number_series),
   
    case Matched_Number_Series  of
	0 ->
	    io:format(""),
	    Mscname0 = string:concat("MSC ",atom_to_list(MSC)),        

	    Msg100= string:concat(Mscname0,": error in SCCP configuration "),
	    request_handler:erlang_send(list_to_atom(Msg100));
	_ ->
	    ok
    end,
    Matched_Number_Series;

get_number_series(bno,MSRN,MSC)->
    Number_series=msc_db:get_number_series(bno,MSC),
    io:format("number_series is ~p",[Number_series]),
    Matched_Number_Series=evaluate_number_series(MSRN,Number_series),

    case Matched_Number_Series  of
	0 ->
	    io:format(""),
	    Mscname0 = string:concat("MSC ",atom_to_list(MSC)),        

	    Msg100= string:concat(Mscname0,": error in Bno configuration "),
	    request_handler:erlang_send(list_to_atom(Msg100));
	_ ->
	    ok
    end,
    Matched_Number_Series.

evaluate_number_series(_,[])->	
    io:format("number_series nooooooot found"),
    0;

evaluate_number_series(NUMBER,[H|T])->
    N= string:len(H),
    Sub_string=string:substr(NUMBER,1,N),
    Result= match_number_series(NUMBER,Sub_string,[H|T]),
    Result.

match_number_series(_,Sub_string,[Sub_string|_T])->
    Sub_string;
match_number_series(NUMBER,_Sub_string,[_Number_series|T])->
    evaluate_number_series(NUMBER,T).
   
    
