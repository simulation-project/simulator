%%%-------------------------------------------------------------------
%%% @author Ahmed Samy <ahm.sam@live.com>
%%% @copyright (C) 2012, Ahmed Samy
%%% @doc
%%%
%%% @end
%%% Created : 17 Jun 2012 by Ahmed Samy <ahm.sam@live.com>
%%%-------------------------------------------------------------------
-module(msc_app_SUITE).

-compile(export_all).

-include_lib("common_test/include/ct.hrl").
%-include_lib("/home/Vendetta/sim_project/simulator/branches/isheash/epgsql/include/epgsql.hrl").

%%--------------------------------------------------------------------
%% @spec suite() -> Info
%% Info = [tuple()]
%% @end
%%--------------------------------------------------------------------
suite() ->
    [{timetrap,{seconds,30}}].

%%--------------------------------------------------------------------
%% @spec init_per_suite(Config0) ->
%%     Config1 | {skip,Reason} | {skip_and_save,Reason,Config1}
%% Config0 = Config1 = [tuple()]
%% Reason = term()
%% @end
%%--------------------------------------------------------------------
init_per_suite(Config) ->
    ok = application:start(sasl),
    ok = application:start(crypto),
    ok = application:start(public_key),
    ok = application:start(ssl),
    true = code:add_path("/home/sony/GP/Alaa/simulator/trunk/epgsql/ebin"),
    ok = application:start(epgsql),
    true = code:add_path("/home/sony/GP/Alaa/simulator/trunk/hlr/ebin"),
    %ok = code:add_path("../hlr/ebin"),
    %ok = application:start(hlr),
    ok = application:start(msc),
    lists:foreach(fun(X) -> code:add_path(X) end, ct:get_config(paths, [])),
    {A1, A2, A3} = now(),
    random:seed(A1, A2, A3),
    dbg:tracer(),
    dbg:p(all, [c, sos, sol]),
    %MaxTime = ct:get_config(max_time, ?MAX_TIME),
    %AdpConf = xml_schema:parse(ct:get_config(conf_file)),
    %[{max_time, MaxTime} | Conf].
    %[{conf, AdpConf} | Conf].
    Config.

%%--------------------------------------------------------------------
%% @spec end_per_suite(Config0) -> void() | {save_config,Config1}
%% Config0 = Config1 = [tuple()]
%% @end
%%--------------------------------------------------------------------
end_per_suite(_Config) ->
    ok = application:stop(sasl),
    ok = application:stop(crypto),
    ok = application:stop(public_key),
    ok = application:stop(ssl),
    ok = application:stop(epgsql),
    %ok = application:stop(hlr),
    ok = application:stop(msc).

%%--------------------------------------------------------------------
%% @spec init_per_group(GroupName, Config0) ->
%%               Config1 | {skip,Reason} | {skip_and_save,Reason,Config1}
%% GroupName = atom()
%% Config0 = Config1 = [tuple()]
%% Reason = term()
%% @end
%%--------------------------------------------------------------------
init_per_group(_GroupName, Config) ->
    Config.

%%--------------------------------------------------------------------
%% @spec end_per_group(GroupName, Config0) ->
%%               void() | {save_config,Config1}
%% GroupName = atom()
%% Config0 = Config1 = [tuple()]
%% @end
%%--------------------------------------------------------------------
end_per_group(_GroupName, _Config) ->
    ok.

%%--------------------------------------------------------------------
%% @spec init_per_testcase(TestCase, Config0) ->
%%               Config1 | {skip,Reason} | {skip_and_save,Reason,Config1}
%% TestCase = atom()
%% Config0 = Config1 = [tuple()]
%% Reason = term()
%% @end
%%--------------------------------------------------------------------
init_per_testcase(_TestCase, Config) ->
    Config.

%%--------------------------------------------------------------------
%% @spec end_per_testcase(TestCase, Config0) ->
%%               void() | {save_config,Config1} | {fail,Reason}
%% TestCase = atom()
%% Config0 = Config1 = [tuple()]
%% Reason = term()
%% @end
%%--------------------------------------------------------------------
end_per_testcase(_TestCase, _Config) ->
    ok.

%%--------------------------------------------------------------------
%% @spec groups() -> [Group]
%% Group = {GroupName,Properties,GroupsAndTestCases}
%% GroupName = atom()
%% Properties = [parallel | sequence | Shuffle | {RepeatType,N}]
%% GroupsAndTestCases = [Group | {group,GroupName} | TestCase]
%% TestCase = atom()
%% Shuffle = shuffle | {shuffle,{integer(),integer(),integer()}}
%% RepeatType = repeat | repeat_until_all_ok | repeat_until_all_fail |
%%              repeat_until_any_ok | repeat_until_any_fail
%% N = integer() | forever
%% @end
%%--------------------------------------------------------------------
groups() ->
    [].

%%--------------------------------------------------------------------
%% @spec all() -> GroupsAndTestCases | {skip,Reason}
%% GroupsAndTestCases = [{group,GroupName} | TestCase]
%% GroupName = atom()
%% TestCase = atom()
%% Reason = term()
%% @end
%%--------------------------------------------------------------------
all() -> 
    [my_test_case].

%%--------------------------------------------------------------------
%% @spec TestCase() -> Info
%% Info = [tuple()]
%% @end
%%--------------------------------------------------------------------
my_test_case() -> 
    [].

%%--------------------------------------------------------------------
%% @spec TestCase(Config0) ->
%%               ok | exit() | {skip,Reason} | {comment,Comment} |
%%               {save_config,Config1} | {skip_and_save,Reason,Config1}
%% Config0 = Config1 = [tuple()]
%% Reason = term()
%% Comment = term()
%% @end
%%--------------------------------------------------------------------
my_test_case(_Config) -> 
    {ok,_Pid} = msc_app:start_msc(msc1),
    %{noreply,_List} = msc_app:location_update_request(60220123456,lai1),
    ok = msc_app:insert_subscriber_data(info,'3-200'),
    ok = msc_app:insert_subscriber_data(602021234567890,info,'3-200').
    %_MSC = msc_app:check_msc_spc(123456,60202123456789).
