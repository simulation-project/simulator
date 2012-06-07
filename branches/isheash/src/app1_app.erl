-module(app1_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1,getInfo/1,getAll/0]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    app1_sup:start_link().

getInfo(Var)->
	app1_ch:getInfo(Var).
getAll()->
	app1_ch:getAll().

stop(_State) ->
    ok.
