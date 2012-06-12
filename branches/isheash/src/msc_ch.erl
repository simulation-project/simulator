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
%%% @author Esraa Adel Mohamed <esraa.elmelegy@gmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(msc_ch).
%-behaviour(gen_server).

%%% Include files

%%% Start/Stop exports
-export([start_link/1]).


%%% Init/Terminate exports
-export([init/1, terminate/2]).

%%% Handle messages exports
-export([handle_call/3, handle_cast/2, handle_info/2]).

%%% Code update exports
-export([code_change/3]).

-compile([export_all]).


%%% Macros

%%% Data types
%% @private
%% @type st() = #st{}.
%%
%% Representation of the server's state etc.
%%
%% <dl>
%%   <dt>: </dt><dd>
%%   </dd>
%% </dl>
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
start_link(Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [Name], []).% gen_server call init that is in this module



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


location_update_request(MSC, {2, 1, IMSI, LAI})->
    gen_server:call(MSC, {2, 1, IMSI, LAI}).
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

handle_call({2, 1, IMSI, LAI}, _From, List) ->
    io:format("aaaaaat child IMSI ~p LAI ~p ~n~n", [IMSI, LAI]),
    Sub_IMSI=string:substr(integer_to_list(IMSI),6),
    MGT=string:concat("2010",Sub_IMSI),
    Sub_MGT=string:substr(MGT,1,5),
    Sub_MGT_DB=list_to_atom(Sub_MGT),
    io:format("~p",[MGT]),
    SPC=msc_db:get_spc(Sub_MGT_DB),
    io:format("Name of msc ~p~n", [SPC]),
    {reply, ok, List};


handle_call(get_all, _From, List) ->
    io:format("handle call in child:~n~n"),
   
    {reply, ok, List};


handle_call({par, _Par}, _From, List) ->
    %L = search_par(Par, List#st.config),
    %io:format("The ~p is: ~p ~n", [Par, L]),
    {reply, no_reply, List}.
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
