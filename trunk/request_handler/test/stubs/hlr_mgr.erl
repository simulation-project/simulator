-module(hlr_mgr).
-export([start_gen/1]).

start_gen(Msg)->
io:format("hlr created :::::: ~p ~n",[Msg]).
