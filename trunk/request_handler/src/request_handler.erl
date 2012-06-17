%%% @doc 
%%%
%%% @copyright 2012 ITI Egypt.
%%% @author Alaa Eldin gamal <alaaeldine1989@yahoo.com>
%%%         [http://www.iti.gov.eg/]
-module(request_handler).
%%% @end

-compile([export_all]).



erlang_receive(newms,Msg)->
ms_app:create_ms(Msg),
io:format("new mobile : ~p ~n",[Msg]),
erlang_send(new_mobile_created);


erlang_receive(mslu,Msg)->
ms_app:change_state(Msg),
io:format("mobile location update : ~p ~n ",[Msg]),
erlang_send(location_update);

erlang_receive(msnormallu,Msg)->
ms_app:change_lai(Msg),
io:format("mobile location update : ~p ~n ",[Msg]),
erlang_send(location_update);

erlang_receive(newhlr,Msg)->
%hlr_mgr:start_gen(Msg),
io:format("new hlr : ~p ~n",[Msg]),
erlang_send(new_hlr);

erlang_receive(newmsc,Msg)->
io:format("before new msc : ~p ~n",[Msg]),
msc_app:start_msc(Msg),
io:format("new msc : ~p ~n",[Msg]),
erlang_send(new_msc_created);

erlang_receive(V,Msg)->
    io:format("nooo match ~p ~p ~n",[V,Msg]).



erlang_send(Msg)->
%M = "outputlog|"+Msg,
    {mbox,java_receiver@localhost} ! Msg.
