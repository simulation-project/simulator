-module(test).
-export([start_select/0, insert/2]).
-include_lib("/home/sony/GP/epgsql/include/pgsql.hrl").
-import(pgsql).


start_select()->
	{ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "mydb"}]),
	{ok, _Columns, Rows} = pgsql:squery(C, "select * from emp"),
	%List = tuple_to_list(Rows),
	show(Rows),
	ok = pgsql:close(C),
	{ok}.

insert(Id, Name)->
	{ok, C} = pgsql:connect("localhost", "postgres", "iti", [{database, "mydb"}]),
	{ok, Count} = pgsql:equery(C, "insert into emp values($1, $2)", [Id, Name]),
	%List = tuple_to_list(Rows),
	io:format("inserted  ~p rows~n", [Count]),
	ok = pgsql:close(C),
	{ok}.

show([])->
	ok;

show([H|T])->
	io:format("emp ~p~n", [H]),
	show(T).

%close()->
 	%ok = pgsql:close(C).

