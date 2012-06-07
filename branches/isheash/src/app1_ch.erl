-module(app1_ch).
-compile(export_all).
-record(st, {config}).
start_link()->
    gen_server:start_link({local,?MODULE},?MODULE,[],[]).

init(_Args)->
code:add_path("/home/sherif/Desktop/app1"),
G=code:priv_dir(app1),
Input=string:concat(G,"/1.txt"),
{ok, L} = file:consult(Input),
    {ok, #st{config=L}}.

getInfo(Var)->
gen_server:call(?MODULE,Var).

getAll()->
gen_server:call(?MODULE,all).


  
handle_call(all,_From,State)->
	X=State#st.config,
	Name=proplists:get_value(name,X),
	Id=proplists:get_value(id,X),
	Loc=proplists:get_value(loc,X),
	io:format("The name is: ~p ~n The ID is: ~p ~n The location is: ~p ~n",[Name,Id,Loc]),
  {reply,done,State};
  
handle_call(Var,_From,State)->
	X=State#st.config,
	Y=proplists:get_value(Var,X),
	io:format("The ~p is: ~p ~n",[Var,Y]),
  {reply,done,State}.
handle_cast(name,State)->
    {noreply,State}.
