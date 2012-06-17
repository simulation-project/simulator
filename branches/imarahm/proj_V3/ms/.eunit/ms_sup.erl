
-module(ms_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

%% @spec start_link() -> startlink_ret
%%    startlink_ret() = {ok, pid()}
%%                    | ignore
%%                    | {error, startlink_err()}
%%    startlink_err() = {already_started, pid()} | shutdown | term()
%% @doc Creates a supervisor process as part of a supervision tree.
%% @end
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    AChild = {ms_fsm_sup,{ms_fsm_sup,start_link,[]},
    permanent,2000,supervisor,[ms_fsm_sup]},
    {ok,{{one_for_one,5,1},[AChild]}}.

