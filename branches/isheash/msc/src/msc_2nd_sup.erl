
-module(msc_2nd_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1,start_msc/1, location_update_request/1, insert_subscriber_data/3]).
-compile([export_all]).
%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_msc(N)->
    supervisor:start_child(?MODULE, [N]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->    
    {ok, { {simple_one_for_one, 5, 10}, [?CHILD(msc_ch,worker)]} }.


location_update_request({2, 1, IMSI, LAI})->
    MSC = msc_db:get_msc_name({LAI,lai}),
    msc_ch:location_update_request({2, 1, IMSI, LAI}, MSC);

location_update_request({2, 2, IMSI, LAI}) ->
    MSC = msc_db:get_msc_name({LAI,lai}),
    msc_ch:location_update_request({2, 2, IMSI, LAI}, MSC).
    

insert_subscriber_data(IMSI,_INFO,SPC )->
    MSC=msc_db:get_msc_name({SPC,spc}),
    msc_ch:insert_subscriber_data(MSC, IMSI, idle).

check_msc_spc(SPC,GT)->
    MSC=msc_db:get_msc_name({GT,gt}),
    X=msc_ch:check_msc_spc(MSC, SPC, GT),
    io:format("XXXXXX ~p",[X]),
    X.
