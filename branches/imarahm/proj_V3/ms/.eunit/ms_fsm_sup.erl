
-module(ms_fsm_sup).

-behaviour(supervisor).

%% API
-export([start_link/0,start_child/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

%% @spec start_link() -> startlink_ret()
%%    startlink_ret() = {ok, pid()}
%%                    | ignore
%%                    | {error, startlink_err()}
%%    startlink_err() = {already_started, pid()} | shutdown | term()
%% @doc Creates a supervisor process as part of a supervision tree.
%% @end

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @spec start_child(Var) -> startchild_ret()
%%    Var = term()
%%    startchild_ret() = {ok, Child :: child()}
%%                     | {ok, Child :: child(), Info :: term()}
%%                     | {error, startchild_err()}
%%    startchild_err() = already_present
%%                     | {already_started, Child :: child()}
%%                     | term()
%% @doc Dynamically adds a child specification to the supervisor SupRef which starts the corresponding child process.
%% @end

start_child(Var)->
    List = tuple_to_list(Var),    
    supervisor:start_child(?MODULE,[List]).
%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok,{{simple_one_for_one,5,10},[?CHILD(ms_fsm,worker)]}}.


