-module(msc_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, start_msc/1, location_update_request/2]).
-compile([export_all]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    msc_1st_sup:start_link().

stop(_State) ->
    ok.

%% ===================================================================
%% export functions
%% ===================================================================




start_msc(Name)->
    msc_2nd_sup:start_msc(Name).

location_update_request(IMSI,LAI)->
    MSC=msc_db:get_msc_name(LAI),
    msc_ch:location_update_request(MSC,IMSI, LAI).

insert_subscriber_data(IMSI,info,spc1 )->
MSC=msc_db:get_msc_name(spc1),    
msc_ch:insert_subscriber_data(MSC, IMSI, idle).
    
