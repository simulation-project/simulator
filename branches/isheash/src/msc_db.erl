-module(msc_db).

-compile([export_all]).

get_msc_name(LAI)->
    
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select * from msc_lai where lai=$1", [LAI]),
    MSC = show(Rows,msc),    
    io:format("Name of msc ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC.
get_spc(MGT)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select * from gt_translation where number_series=$1", [MGT]),
    SPC = show(Rows,spc),
    SPC.








show([],_)->
    not_found;
show([H|_],msc)->
    {A, _} = H,
    C = list_to_atom(binary_to_list(A)),
    C;
show([H|_],spc)->
    {_,S} = H,
    C = list_to_atom(binary_to_list(S)),
    C.    
