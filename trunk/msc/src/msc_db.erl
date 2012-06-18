%%% Copyright (C) 2012 ITI Egypt.
%%%
%%% The contents of this file are subject to the Erlang Public License,
%%% Version 1.1, (the "License"); you may not use this file except in
%%% compliance with the License. You should have received a copy of the
%%% Erlang Public License along with this software. If not, it can be
%%% retrieved via the world wide web at http://www.erlang.org/.
%%%
%%% Software distributed under the License is distributed on an "AS IS"
%%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%%% the License for the specific language governing rights and limitations
%%% under the License.
%%%
%%% The Initial Developer of the Original Code is Ericsson Utvecklings AB.
%%% Portions created by Ericsson are Copyright 1999, Ericsson Utvecklings
%%% AB. All Rights Reserved.

%%% @doc 
%%% This module is responsible of handling all the requests from %%% the MSC to the Database.
%%% @copyright 2012 ITI Egypt.
%%% @author Esraa Adel <esraa.elmelegy@hotmail.com>
%%% @author Sherif Ashraf <sherif_ashraf89@hotmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end

-module(msc_db).


%%% External exports
-export([ get_msc_name/1, get_SPC/1, get_GT/1, get_VLR/1, insert_subscriber/4, update_subscriber_info/2, check_msc_imsi/2]).

-compile([export_all]).

%% ===================================================================
%% External exports
%% ===================================================================
%% @spec get_msc_name({Parameter1, Parameter2}) -> Result
%%    Result = atom()
%%    Parameter1 = SPC | LAI | GT  
%%    Parameter2 = spc | lai | gt | gt
%%    SPC = atom()
%%    LAI = atom()
%%    GT = atom()
%% @doc This function returns the MSC name for a given Input Parameter .
%% @end
get_msc_name({SPC,spc}) ->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select name from msc_data where ni_spc=$1", [SPC]),
    MSC = show(Rows),    
    io:format("msc_db:get_msc_name(SPC):  ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC;    
get_msc_name({LAI,lai})->    
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select msc_name from msc_lai where lai=$1", [LAI]),
    MSC = show(Rows),    
    io:format("msc_db:get_msc_name(LAI):  ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC;
get_msc_name({GT,gt}) ->
   {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select name from msc_data where gt=$1", [GT]),
    MSC = show(Rows),    
    io:format("msc_db:get_msc_name(GT):  ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC;
get_msc_name({SPC,GT}) ->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select name from msc_data where ni_spc=$1 and gt=$2 ", [SPC,GT]),
    MSC = show(Rows),    
    io:format("msc_db:get_msc_name(SPC,GT):  ~p~n", [MSC]),
    ok = pgsql:close(C),
    MSC.   

%% @spec get_SPC(MGT) -> Result
%%    Result = atom()
%%    MGT = atom()  
%%% @doc This function returns the SPC for a given MGT .
%% @end
get_SPC(MGT)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select spc from gt_translation where number_series=$1", [MGT]),
    SPC = show(Rows),
    SPC.

%% @spec get_GT(VLR) -> Result
%%    Result = atom()
%%    VLR = atom()  
%%% @doc This function returns the GT for a given VLR .
%% @end
get_GT(VLR)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select gt from msc_data where vlr_add=$1", [VLR]),
    GT = show(Rows),
    GT.

%% @spec get_VLR(MSC) -> Result
%%    Result = atom()
%%    MSC = atom()  
%%% @doc This function returns the VLR address for a given MSC .
%% @end
get_VLR(MSC)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _C, Rows} = pgsql:equery(C, "select vlr_add from msc_data  where name=$1", [MSC]),    
    VLR = show(Rows),
    io:format("msc_db:get_VLR(MSC):  ~p~n",[VLR]),
    VLR.

%% @spec insert_subscriber(IMSI, LAI, MSC, VLR) -> Result
%%   IMSI = atom()
%%   LAI = atom()
%%   MSC = atom()
%%   VLR = atom()  
%%   Result = ok
%%% @doc This function inserts the Input data for a given IMSI into the Database.
%% @end
insert_subscriber(IMSI,LAI,MSC,VLR)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _I} = pgsql:equery(C, "insert into sub_info values ($1, $2, $3, $4, $5)", [MSC, VLR, 'null', IMSI, LAI]),   
    io:format("msc_db:insert_subscriber_data: done  ~n").

%% @spec update_subscriber_info(Parameter, Status) -> Result
%%   Parameter = IMSI | {IMSI, LAI, MSC, VLR} | {IMSI, LAI}
%%   IMSI = atom()  
%%   LAI = atom()
%%   MSC = atom()
%%   VLR = atom()
%%   Status = idle | newstatus
%%   Result = ok
%%% @doc This function updates the status for a given IMSI .
%% @end
update_subscriber_info(IMSI,idle)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _} = pgsql:equery(C, "update sub_info  set status=$1 where imsi=$2", [idle,IMSI]),
    io:format("msc_db:update_subscriber_info(turn_on): done  ~n");
update_subscriber_info({IMSI,LAI,MSC,VLR},newstatus)->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _} = pgsql:equery(C, "update sub_info  set msc_name=$1,vlr_add=$2,lai=$3,status=$4 where imsi=$5", [MSC,VLR,LAI,idle,IMSI]),
    io:format("msc_db:update_subscriber_info(inter msc): done  ~n");
update_subscriber_info(IMSI, LAI) ->
    {ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
    {ok, _} = pgsql:equery(C, "update sub_info set lai=$1 where imsi=$2", [LAI, IMSI]),
    io:format("msc_db:update_subscriber_info(intra msc): done  ~n").
%% @spec check_msc_imsi(MSC, IMSI) -> Result
%%   MSC = atom() 
%%   IMSI = atom()   
%%   Result = atom()
%%% @doc This function checks that the IMSI belongs to the given MSC .
%% @end
check_msc_imsi(MSC, IMSI)->
{ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "msc"}]),
{ok, _C, Rows} = pgsql:equery(C, "select msc_name from sub_info where msc_name = $1 and imsi=$2", [MSC, IMSI]),
R = show(Rows),
R.


%% ===================================================================
%% Internal exports
%% ===================================================================
%% @spec show([L]) -> Result
%%   L = binary()
%%   Result = atom()   
%%% @doc This function converts from binary to atom .
%% @end
show([])->
    not_found;

show([H|_])->
    {A} = H,
    C = list_to_atom(binary_to_list(A)),
    C.
