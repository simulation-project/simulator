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
%%% @author Ahmed Gamal <eng_ahmedgamal2011@hmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(hlr_server).
-behaviour(gen_server).

%%% Include files
-include_lib("../../epgsql/include/pgsql.hrl").
%%% Start/Stop exports
-export([start_link/1]).

%%% External exports
-export([call/1]).

%%% Init/Terminate exports
-export([init/1, terminate/2]).

%%% Handle messages exports
-export([handle_call/3, handle_cast/2, handle_info/2]).

%%% Code update exports
-export([code_change/3]).

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
-record(st, {conf}).

%%%-----------------------------------------------------------------------------
%%% Start/Stop exports
%%%-----------------------------------------------------------------------------
%% @spec start_link() -> Result
%%    Result = {ok, Pid} | ignore | {error, Error}
%%    Pid = pid()
%%    Error = {already_started, Pid} | term()
%%
%% @doc Starts the server. Explain something about startup sequence...
%%
%% @see gen_server
%% @see start/0
%% @end
start_link(Conf) ->
    Name = proplists:get_value(hlr_name,Conf),
    A = list_to_atom(Name),
    {ok, PID} = gen_server:start_link({local, A}, ?MODULE, [], []),
    %%io:format("hlr : ~p starts with configuration :  ~p~n", [A, Conf]),
   NEWL=[{pid,PID}|Conf],
    gen_server:call(A,  {addConf,  NEWL}, 1000),
    %%PID ! {addConf,  NEWL},
    {ok, PID}.


%%%-----------------------------------------------------------------------------
%%% External exports
%%%-----------------------------------------------------------------------------
call({addConf, Conf}) ->
    gen_server:call(?MODULE, {addConf, Conf}, 1000);
call({updateLocation, L}) ->
    gen_server:call(?MODULE, {updateLocation, L}, 1000).


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
init([]) ->
    {ok, #st{}}.

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
       io:format("terminate is called~n"),
    ok.

%%%-----------------------------------------------------------------------------
%%% Handle messages exports
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
handle_call({addConf, Conf}, _From, _St) ->
    {reply, ok,  #st{conf= Conf}};
handle_call({updateLocation, Name, L}, _From, St) ->
    {IMSI,VLR,GT}=L,
    LU={6,1,IMSI,VLR,GT},
    {reply, updateLocation(Name, LU), St};
handle_call(printAllSd, _From, St) ->
    {reply, printAllSd(), St};
handle_call({insert,IMSI,ISD}, _From, St) ->
    {reply, insert(IMSI, ISD), St};
handle_call(getSpc, _From, St) ->
    {reply,  getSpc(St), St};
handle_call(getGt, _From, St) ->
     {reply,  getGt(St), St};
handle_call({sendroutinginfo,BNO,MSC1GT,HLRName}, _From, St) ->
       {reply,  sri(BNO,MSC1GT,HLRName), St}.


%% @private
%% @spec handle_cast(Req, St) -> Result
%%    Req = term()
%%    Result = {noreply, NewSt} |
%%             {noreply, NewSt, Timeout} |
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
handle_cast(_Req, St) ->
    {noreply, St}.


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


handle_info(_info, St) ->
    io:format("handle info is called~n"),
   {noreply, St}.
%%handle_info( {addConf, L}, St) ->
%%    {noreply,  #st{conf=L}};
%%handle_info(getConf,St) ->
%%    {st,M} = St,
%%    io:format("The states of HLR are :  ~p~n", [M]),
%%    {noreply,  St};
%%handle_info(getSpc, St) ->
%%      {st,M} = St,
%%    SPC = proplists:get_value(spc,M),
%%    io:format("The SPC of HLR are :  ~p~n", [SPC]),
%%    {noreply,  St};
%%handle_info(getGt, St) ->
%%      {st,M} = St,
%%    GT = proplists:get_value(gt,M),
%%    io:format("The GT of HLR are :  ~p~n", [GT]),
%%    {noreply,  St}.

%%%-----------------------------------------------------------------------------
%%% Code update exports
%%%-----------------------------------------------------------------------------
%% @private
%% @spec code_change(OldVsn, St, Extra) -> {ok, NewSt}
%%    OldVsn = undefined | term()
%%    St = term()
%%    Extra = term
%%    NewSt = term()
%%
%% @doc Converts the process state when code is changed.
%% @end
code_change(_OldVsn, St, _Extra) ->
    {ok, St}.

%%%-----------------------------------------------------------------------------
%%% Internal functions
%%%-----------------------------------------------------------------------------
%%---------------------------------------------------------------------------------
updateLocation(Name, {6,1,IMSI,VLR,CgPA}) ->
    insertVlr(Name, IMSI, VLR, CgPA).

%%update vlr in DB
%%get subscriber_info from DB 
%%translate gt to spc to msc_name
%%msc_name:call(subscriber_info)
%---------------------------------------------------------------------------------
insertVlr(Name, IMSI, VLR, CgPA)->
     {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "hlr"}]),
     %%{ok, _C, Rows} = pgsql:squery(C, "select * from hlr1"),
    DB = Name,
    Query = "update " ++ DB ++ " set vlr=$1 where imsi=$2",
    {ok, _Count} = pgsql:equery(C, Query, [VLR, IMSI]),
    %%io:format("updated ~p rows~n", [Count]),
    %%io:format("IMSI : ~p is updated to VLR address : ~p ~n", [IMSI, VLR]), 

    Msg1 = "HLR " ++ Name ++" : IMSI " ++ atom_to_list(IMSI) ++ " is updated to VLR address " ++ atom_to_list(VLR) ++ " successfuly", %%IMSI
    request_handler:erlang_send(list_to_atom(Msg1)),

    Query2 = "select isd from " ++ DB ++ "  where imsi=$1 ",
    {ok, _C, ISD} = pgsql:equery(C, Query2, [IMSI]),
    ok = pgsql:close(C),
    sendISD(CgPA,ISD,IMSI, Name).
%---------------------------------------------------------------------------------
sendISD(MSCGT,ISD,IMSI, Name)->
    %%io:format("~n~n send ISD  at HLR    ~p~n ~p ~n~n",[MSCGT,ISD]),
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "hlr"}]),
    DB = "node_" ++ Name,
    Query = "select nispc from " ++ DB ++ "  where gt=$1 ",
    {ok, _C, SPC} = pgsql:equery(C, Query, [MSCGT]),
    ok = pgsql:close(C),
    %%MSC_name=msc_app:call(Rows),
    [{A}]=ISD,
    [{B}]=SPC,
    NISD = binary_to_list(A),
    NSPC = binary_to_list(B),
    checkMscSpc(MSCGT,NSPC,IMSI,NISD, Name).
%% io:format("MSC GT ... ~p....IMSI .... ~p ..ISD .. ~p ..... SPC....~p ~n",[MSCGT,IMSI,NISD,NSPC]).
%%msc_app:insert_subscriber_data(IMSI, NISD, NSPC).
%---------------------------------------------------------------------------------
checkMscSpc(MSCGT,SPC,IMSI,ISD, Name)->
    ASPC = list_to_atom(SPC),
    Return = msc_app:check_msc_spc(ASPC, MSCGT),
    checkReturn(Return,SPC,IMSI,ISD, Name).
%--------------------------------
checkReturn([], _SPC, _IMSI, _ISD, _Name)->
   %% io:format("This SPC is not belong to this MSC !!! ");
    Msg1 = "This SPC is not belong to this MSC !!! ",
    request_handler:erlang_send(list_to_atom(Msg1)) ;

checkReturn(_,SPC,IMSI,ISD, Name) ->
    msc_app:insert_subscriber_data(IMSI, ISD, SPC),

    Msg2 = "HLR" ++ Name ++ " : ISD " ++ ISD ++ " is sent from HLR "++ Name ++ " to MSC that has SPC "++ SPC ++ " successfuly",
    request_handler:erlang_send(list_to_atom(Msg2)).

%%io:format("ISD is sent from hlr to msc successfuly~n").

%%---------------------------------------------------------------------------------    
printAllSd()->    	
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "hlr"}]),
    {ok, _C, Rows} = pgsql:squery(C, "select * from hlr1"),
    %%B = show(Rows),
    io:format("hlr1 all data ~p~n", [Rows]),
    ok = pgsql:close(C).
%%---------------------------------------------------------------------------------
insert(IMSI,ISD)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "hlr"}]),
    D = pgsql:equery(C, "insert into hlr1 (imsi,isd) values ($1,$2)", [IMSI,ISD]),
    check(D),
    ok = pgsql:close(C).


check({ok,Count})->
    io:format("inserted  ~p rows~n", [Count]);
check({error,_}) ->
    io:format("primary key must be unique~n").

%%---------------------------------------------------------------------------------
getSpc(St)->
     {st,M} = St,
    _SPC = proplists:get_value(spc,M).

%%---------------------------------------------------------------------------------
getGt(St)->
    {st,M} = St,
    _GT= proplists:get_value(gt,M).




%%------------------------------------------------------------------------------
sri(BNO,MSC1GT,HLRName)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "hlr"}]),

    DB = atom_to_list(HLRName),
    Query = "select imsi from " ++ DB ++ "  where isd=$1 ",
    {ok, _, BIMSI} = pgsql:equery(C, Query, [BNO]),


    DB2 = "node_" ++ atom_to_list(HLRName),
    Query2 = "select nispc from " ++ DB2 ++ "  where gt=$1 ",
    {ok, _, MSC1SPC} = pgsql:equery(C, Query2, [MSC1GT]),
    

    Query3 = "select vlr from " ++ DB ++ "  where isd=$1 ",
    {ok, _, MSC2GT} = pgsql:equery(C, Query3, [BNO]), 
    [{A}] = BIMSI,
    [{B}] =  MSC1SPC,
    [{C1}] =  MSC2GT,
    NBIMSI = binary_to_list(A),
    NMSC1SPC = binary_to_list(B),
    NMSC2GT = binary_to_list(C1),
    %%io:format("DBBB>>>> ~p ~n~n~n~n~n",[NMSC2GT]),
    Query4 = "select nispc from " ++ DB2 ++ "  where gt=$1 ",
    {ok, _, MSC2SPC} = pgsql:equery(C, Query4, [NMSC2GT]),
    %%io:ioformat("DBBB>>>> ~p   ~p  ~n~n~n~n~n",[NBIMSI,MSC2SPC]),
    [{D}] =  MSC2SPC,
    NMSC2SPC = binary_to_list(D),
    ok = pgsql:close(C),
 
    MSRN = msc_app:receive_PRN({6,5,list_to_atom(NBIMSI),list_to_atom(NMSC2SPC)}),
    %%io:format(" MSRN ....................... : ~p~n",[MSRN]),
    
    Msg1 = "HLR " ++ HLRName ++ " : Send Routing Info Request of B Number " ++ BNO ++ " from MSC1 that has Gt " ++ MSC1GT ,
    request_handler:erlang_send(list_to_atom(Msg1)),
   
    Msg2 = "HLR " ++ HLRName ++ " : This B Numer " ++ BNO ++ " has IMSI " ++ NBIMSI ++ " and VLR Address " ++ NMSC2GT , 
    request_handler:erlang_send(list_to_atom(Msg2)),
 
    Msg3 = "HLR " ++ HLRName ++ " : SCCP Analysis MSC2 VLR Address " ++ NMSC2GT ++ " -> MSC2 SPC " ++ NMSC2SPC,
    request_handler:erlang_send(list_to_atom(Msg3)),

    Msg4 = "HLR " ++ HLRName ++ " : Provide Rooming number request to MSC2 that has SPC " ++ NMSC2SPC,
    request_handler:erlang_send(list_to_atom(Msg4)),

    Msg5 = "HLR " ++ HLRName ++ " : Provide Rooming number Answer from MSC2 by MSRN " ++ atom_to_list(MSRN),
    request_handler:erlang_send(list_to_atom(Msg5)),


    Msg6 = "HLR " ++ HLRName ++ " : SCCP Analysis MSC1 GT " ++ MSC1GT ++ " -> MSC1 SPC " ++ NMSC1SPC,
    request_handler:erlang_send(list_to_atom(Msg6)),

    Msg7 = "HLR " ++ HLRName ++ " : Send Routing Info Answer to MSC1 by MSRN " ++  atom_to_list(MSRN),
    request_handler:erlang_send(list_to_atom(Msg7)),


    msc_app:result_SRI({6,7,MSRN, NMSC1SPC}).
    
