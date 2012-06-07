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
-module(app_server).
-behaviour(gen_server).

%%% Include files

%%% Start/Stop exports
-export([start_link/0]).

%%% External exports
-export([get_info/0, get_par/1]).

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
%% Representation of the server's state etc.
%%
%% <dl>
%%   <dt>: </dt><dd>
%%   </dd>
%% </dl>
-record(st, {config}).

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
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).% gen_server call init that is in this module

%%%-----------------------------------------------------------------------------
%%% External exports
%%%-----------------------------------------------------------------------------
%% @spec get_info() -> Result
%%    Result = atom().
%%    
%% @doc get all information from configuration file. 
%%
%% @end
get_info()->
    R=gen_server:call(?MODULE,get_all),% gen_server call handle_call in this module
    io:format("Reply is ----> ~p~n", [R]).

%% @spec get_par(Par) -> Result
%%    Par = string().
%%    Result = atom().
%%    
%% @doc get information from configuration file according to some parameter. 
%%
%% @end
get_par(Par)->
    R=gen_server:call(?MODULE,{par, Par}),% gen_server call handle_call in this module
    io:format("The ~p is: ~p~n", [Par, R]).
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
    io:format("Init function is called ~n~n"),
    code:add_path("/home/sony/erlang/app"),
    Dir_path = code:priv_dir(app),
    File_Path = string:concat(Dir_path, "/f.txt"),
    
    {ok, L} = file:consult(File_Path),
    {ok, #st{config = L}}.

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
handle_call(get_all, _From, List) ->
    io:format("All Information is:~n~n"),
   
    N = search_par(name, List#st.config),
    io:format("The name is: ~p ~n", [N]),

    I = search_par(id, List#st.config),
    io:format("The ID is: ~p ~n", [I]),

    C = search_par(cell, List#st.config),
    io:format("The cells are: ~p ~n", [C]),

    {reply, reply_stom, List};


handle_call({par, Par}, _From, List) ->
    L = search_par(Par, List#st.config),
    %io:format("The ~p is: ~p ~n", [Par, L]),
    {reply, L, List}.
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
%%%-----------------------------------------------------------------------------
search_par(Value, L)->    % L -> [{key, value}, {key, value}]
	I = proplists:get_value(Value, L),
	I.

