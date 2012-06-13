-module(msc_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, start_msc/1, location_update_request/2]).
-compile([export_all]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    code:add_path("test/stub"),
    msc_1st_sup:start_link().

stop(_State) ->
    ok.

%% ===================================================================
%% export functions
%% ===================================================================




start_msc(Name)->
    msc_2nd_sup:start_msc(Name).

location_update_request(IMSI,LAI)->
    msc_2nd_sup:location_update_request(IMSI, LAI).

insert_subscriber_data(IMSI,INFO,SPC)->
    msc_2nd_sup:insert_subscriber_data(IMSI, INFO, SPC).
