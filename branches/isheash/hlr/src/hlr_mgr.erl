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
-module(hlr_mgr).
-behaviour(gen_server).

%%% Include files

%%% Start/Stop exports
-export([start_link/0]).

%%% External exports
-export([start_gen/1, printRegServers/0, imsiExist/2, getNameBySpc/1,update_location/2]).
%%export([printHlrData/1,printHlrSpc/1,printHlrGt/1]).
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
-record(st, {servers}).

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
start_link() ->
   %% hlr_gen_event:register( ?MODULE),
    io:format("HLR manager starts.......~n"),
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
  
%%%-----------------------------------------------------------------------------
%%% External exports
%%%-----------------------------------------------------------------------------
start_gen(Conf)->
    %%N = proplists:get_value(hlr_name,C),
    %%S = string:concat("hlr",N),
    %%L=[{hlr_fullname,S}|C],
    {ok,PID} = hlr_server:start_link(Conf),
    SPC =  proplists:get_value(spc, Conf),
    Name = proplists:get_value(hlr_name,Conf),
    gen_server:call(?MODULE, {save, {Name,SPC,PID}}, infinity),
    io:format("Hlr Starts with configuration  : ~p~n", [Conf]).
%%%----------------------------------------------------------------------
printRegServers()->
  gen_server:call(?MODULE, printAll, 1000).

%%%----------------------------------------------------------------------
imsiExist(SPC,IMSI)->
    Name = getNameBySpc(SPC),
    imsi_exist(Name,IMSI).
%%----------------------------------------------------------------------
imsi_exist(_Name,Imsi)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "hlr"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select * from hlr1  where imsi=$1",[Imsi]),
    ok = pgsql:close(C),
    check(Rows).
%%----------------------------------------------------------------------	
check([])->
    false;
check(_R) ->
    ok.
%%%----------------------------------------------------------------------
update_location(L,SPC)->
    Name = getNameBySpc(SPC),
    AName =  list_to_atom(Name),
    gen_server:call(AName, {updateLocation, L},infinity).
%%-----------------------------------------------------------------------
getNameBySpc(SPC)->
  gen_server:call(?MODULE, {getName,SPC}, infinity).
%%%----------------------------------------------------------------------
%%printHlrData(Name)->
%%  gen_server:call(?MODULE, {printHlrData, Name}, 1000).
%%----------------------------------------------------------------------
%%printHlrSpc(Name)->
%%  gen_server:call(?MODULE, {getSpc, Name}, 1000).

%%----------------------------------------------------------------------
%%printHlrGt(Name)->
%%  gen_server:call(?MODULE, {getGt, Name}, 1000).
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
    {ok, #st{servers=[]}}.

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
handle_call({save, {Name,SPC,PID}}, _From, St) ->
    {st,M}=St,
    io:format("manager :handle Call : servers are saved : ~p~n", [[  {Name,SPC,PID}|M]]),
    {reply, ok, {st, [{Name,SPC,PID}|M]} };
handle_call(printAll,  _From, St) ->
    {st,M}=St,
    io:format("manager : servers are  ~p~n", [M]),
    {reply, ok, St };
handle_call({getName, SPC},  _From, St) ->
   %% io:format("manager : get Name of SPC ~p~n", [SPC]),
    {st,L}=St,
    {reply, getName({SPC,L}), St }.

%%handle_call({printHlrData, Name}, _From, St) ->
%%    {st,M}=St,
%%    PID = proplists:get_value(Name,M),
%%    PID ! getConf,
%%    {reply, ok, St };
%%handle_call( {getSpc, Name}, _From, St) ->
%%    {st,M}=St,
%%    PID = proplists:get_value(Name,M),
%%    PID ! getSpc,
%%    {reply, ok, St };
%%handle_call( {getGt, Name}, _From, St) ->
%%     {st,M}=St,
%%    PID = proplists:get_value(Name,M),
%%    PID ! getGt,
%%    {reply, ok, St }.

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
handle_info(_Info, St) ->
    {noreply, St}.

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
%%%----------------Name-------------------------------------------------------------
%%getName({SPC, St})->
%%    {st,L}=St,
%%    search({SPC, L}).

getName({SPC, [{Name,SPC,_PID}|_T]})->
io:format("hlr name : ~p~n", [Name]),
    Name;
getName({SPC, [_H|T]}) ->
    getName({SPC,T}).
    
%%---------------------------------------------------------------------------------
	
	
