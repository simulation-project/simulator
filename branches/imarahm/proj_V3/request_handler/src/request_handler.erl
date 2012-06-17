%%% @doc 
%%%
%%% @copyright 2012 ITI Egypt.
%%% @author Alaa Eldin gamal <alaaeldine1989@yahoo.com>
%%%         [http://www.iti.gov.eg/]
-module(request_handler).
%%% @end

-compile([export_all]).



erlang_receive(newms,Msg)->
io:format("new mobile request : ~p ~n",[Msg]),
ms_app:create_ms(Msg),
erlang_send(new_mobile_created);


erlang_receive(mslu,Msg)->
io:format("mobile location update request : ~p ~n ",[Msg]),
ms_app:change_state(Msg),
erlang_send(location_update);

erlang_receive(msnormallu,Msg) ->
io:format("normal location update : ~p ~n",[Msg]),
ms_app:change_lai(Msg),
erlang_send(normal_locatio_update);

erlang_receive(newhlr,Msg)->
io:format("new hlr request : ~p ~n",[Msg]),
%hlr_mgr:start_gen(Msg),
erlang_send(new_hlr);

erlang_receive(newmsc,Msg)->
io:format("new msc request : ~p ~n",[Msg]),
%msc_app:start_msc(Msg),
erlang_send(new_msc_created);

erlang_receive(V,Msg)->
    io:format("nooo match ~p ~p ~n",[V,Msg]).



erlang_send(Msg)->
    H='outputloglog|',
    Hs=atom_to_list(H),
    Msgs=atom_to_list(Msg),
    Ms=string:concat(Hs,Msgs),
    M=list_to_atom(Ms),
						%M = "outputlog|"+Msg,
    {mbox,java_receiver@localhost} ! M.
