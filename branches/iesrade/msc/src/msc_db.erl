-module(msc_db).

-compile([export_all]).
get_msc_name(spc1) ->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select name from msc_data where ni_spc=$1", ['spc1']),
    MSC = show(Rows),    
    io:format("Name of msc of spc1  ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC;    
get_msc_name(LAI)->    
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select msc_name from msc_lai where lai=$1", [LAI]),
    MSC = show(Rows),    
    io:format("Name of msc ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC.


get_spc(MGT)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select spc from gt_translation where number_series=$1", [MGT]),
    SPC = show(Rows),
    SPC.


get_GT(VLR)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select gt from msc_data where vlr_add=$1", [VLR]),
    GT = show(Rows),
    GT.

insert_subscriber(IMSI,LAI,MSC,VLR)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _I} = pgsql:equery(C, "insert into sub_info values ($1, $2, $3, $4, $5)", [MSC, VLR, 'null', IMSI, LAI]),   
    io:format("doooooone insertion").


get_VLR(MSC)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select vlr_add from msc_data  where name=$1", [MSC]),    
    VLR = show(Rows),
    io:format("VLLLLLLRRRRRRRRRRR ~p~n~n",[VLR]),
    VLR.


update_subscriber_info(IMSI,idle)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _} = pgsql:equery(C, "update sub_info  set status=$1 where imsi=$2", [idle,IMSI]),
    io:format("heeeeeeeeeeeeh").

show([])->
    not_found;

show([H|_])->
    {A} = H,
    C = list_to_atom(binary_to_list(A)),
    C.
