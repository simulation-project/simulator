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

erlang_receive(call_request,Msg)->
ms_app:call_setup(Msg),
io:format("mobile call request : ~p ~n ",[Msg]),
erlang_send(call_request);

erlang_receive(accept_call,{IMSI,LAI})->
ms_app:connect_msg(IMSI,LAI),
io:format("mobile accept msg : ~p   ~p ~n ",[IMSI,LAI]),
erlang_send(accept_call);

erlang_receive(newhlr,Msg)->
io:format("new hlr : ~p ~n",[Msg]),
hlr_mgr:start_gen(Msg),
erlang_send(new_hlr_crteated);

erlang_receive(newmsc,Msg)->
io:format("before new msc : ~p ~n",[Msg]),
msc_app:start_msc(Msg),
io:format("new msc : ~p ~n",[Msg]),
erlang_send(new_msc_created);

erlang_receive(V,Msg)->
    io:format("nooo match ~p ~p ~n",[V,Msg]).



erlang_send(Msg)->
H='outputlog|',
Hs=atom_to_list(H),
Msgs=atom_to_list(Msg),
Ms=string:concat(Hs,Msgs),
M=list_to_atom(Ms),
{mbox,java_receiver@localhost} ! M,
data_sent.


erlang_send2(Msg)->
H='signal|',
Hs=atom_to_list(H),
Msgs=atom_to_list(Msg),
Ms=string:concat(Hs,Msgs),
M=list_to_atom(Ms),
{mbox,java_receiver@localhost} ! M,
data_sent.





