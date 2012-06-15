-module(msc_db).

-compile([export_all]).
get_msc_name({SPC,spc}) ->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select name from msc_data where ni_spc=$1", [SPC]),
    MSC = show(Rows),    
    io:format("Name of msc of spc1  ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC;    
get_msc_name({LAI,lai})->    
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select msc_name from msc_lai where lai=$1", [LAI]),
    MSC = show(Rows),    
    io:format("Name of msc ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC;
get_msc_name({GT,gt}) ->
   {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select name from msc_data where gt=$1", [GT]),
    MSC = show(Rows),    
    io:format("Name of msc gtttt  ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC;
get_msc_name({SPC,GT}) ->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select name from msc_data where ni_spc=$1 and gt=$2 ", [SPC,GT]),
    MSC = show(Rows),    
    io:format("Name of msc spc gtt ~p~n", [MSC]),
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

check_msc_imsi(MSC, IMSI)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select imsi from sub_info where msc_name = $1 and imsi=$2", [MSC, IMSI]),
    IMSI = show(Rows),
    IMSI.


show([])->
    not_found;

show([H|_])->
    {A} = H,
    C = list_to_atom(binary_to_list(A)),
    C.
