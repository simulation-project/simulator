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
%%% This is the supervisor that starts the supervisor which 
%%% handles the MSCs
%%% @copyright 2012 ITI Egypt.
%%% @author Esraa Adel <esraa.elmelegy@hotmail.com>
%%% @author Sherif Ashraf <sherif_ashraf89@hotmail.com>
%%% @author Ahmed Samy <ahm.sam@live.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(msc_1st_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

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
    Achild={msc_2nd_sup,{msc_2nd_sup,start_link,[]},
	    permanent,5000,supervisor,[msc_2nd_sup]},
    {ok, { {one_for_one, 5, 10}, [Achild]} }.

