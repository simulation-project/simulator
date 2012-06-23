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
%%%
%%% @copyright 2012 ITI Egypt.
%%% @author Marwa El-Shahed <marwa.elshahed@hotmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(ms_app_SUITE).

%%% Include files
%-include("/usr/lib/erlang/lib/common_test-1.5.5/include/ct.hrl").
%-include("ct.hrl").

%%% External exports
-compile(export_all).

%%% Macros
-define(MATCH_SPEC, [{'_', [], [{message, {return_trace}}]}]).
-define(MAX_TIME, 10000).
-define(STUBS_DIR, "../../stubs").  % Tests run in log/ct_run.*


%%%-----------------------------------------------------------------------------
%%% Suite Exports
%%%-----------------------------------------------------------------------------
%% @spec all() -> Result
%%    Result = TestCases | {skip, Reason}
%%    TestCases = [TestCase]
%%    TestCase = atom()
%%    Reason   = term()
%%
%% @doc Returns the list of test cases that are to be executed.
%% @end
all() ->
    [normal_case].

%% @spec sequences() -> Sequences
%%    Sequences = [{Name, Cases}]
%%    Name = atom()
%%    Cases = [Case]
%%    Case = atom()
%%
%% @doc Specifies test case sequences.
%% @end
sequences() ->
    [].

%% @spec suite() -> Info
%%    Info = [tuple()]
%%
%% @doc Returns a list of tuples to set default properties for the suite.
%% @end
suite() ->
    [{timetrap, {minutes, 60}},
     {required, conf_file}].

%%%-----------------------------------------------------------------------------
%%% Init Suite Exports
%%%-----------------------------------------------------------------------------
%% @spec init_per_suite(Conf) -> Conf
%%     Conf = [tuple()]
%%
%% @doc Initiation before the whole suite.
%%
%% <b>Note:</b> This function is free to add any key/value pairs to the
%% <u>Conf</u> variable, but should NOT alter/remove any existing entries.
%% @end
init_per_suite(Conf) ->
    ok = application:start(sasl),
    ok = application:start(ms),
    lists:foreach(fun(X) -> code:add_path(X) end, ct:get_config(paths, [])),
    {A1, A2, A3} = now(),
    random:seed(A1, A2, A3),
    dbg:tracer(),
    dbg:p(all, [c, sos, sol]),
    %MaxTime = ct:get_config(max_time, ?MAX_TIME),
    %AdpConf = xml_schema:parse(ct:get_config(conf_file)),
    %[{max_time, MaxTime} | Conf].
    %[{conf, AdpConf} | Conf].
    Conf.

%%%-----------------------------------------------------------------------------
%%% End Suite Exports
%%%-----------------------------------------------------------------------------
%% @spec end_per_suite(Conf) -> Result
%%    Conf = [tuple()]
%%    Result = ok | {save_config, Conf1}
%%
%% @doc Cleanup after the suite.
%% @end
end_per_suite(_Conf) ->
    ok = application:stop(ms),
    ok = application:stop(sasl).

%%%-----------------------------------------------------------------------------
%%% Init Case Exports
%%%-----------------------------------------------------------------------------
%% @spec init_per_testcase(Case, Conf) -> Result
%%    Case = atom()
%%    Conf = [tuple()]
%%    Result = NewConf |
%%             {skip, Reason} |
%%             {skip_and_save, Reason, NewConf}
%%    NewConf = [tuple()]
%%    Reason = term()
%%
%% @doc Initialization before each test case.
%% @end
init_per_testcase(Case, Conf) ->
    ct:print("Starting test case ~p", [Case]),
    init_stubs(Case),
    init_traces(Case),
    Conf.

init_stubs(Case) ->
    NegCases = ct:get_config(neg_cases, []),
    Stubs = proplists:get_value(Case, NegCases, []),
    lists:foreach(fun(Stub) -> load_stub(Stub, true) end, Stubs).

init_traces(Case) ->
    TpCases = ct:get_config(tp_cases, []),
    Tps = proplists:get_value(Case, TpCases, []),
    lists:foreach(fun(Tp) -> add_trace(tp, Tp) end, Tps),
    TplCases = ct:get_config(tpl_cases, []),
    Tpls = proplists:get_value(Case, TplCases, []),
    lists:foreach(fun(Tpl) -> add_trace(tp, Tpl) end, Tpls).

%%%-----------------------------------------------------------------------------
%%% End Case Exports
%%%-----------------------------------------------------------------------------
end_per_testcase(Case, Conf) ->
    end_traces(Case),
    end_stubs(Case),
    ct:print("Test case ~p completed", [Case]),
    Conf.

end_stubs(Case) ->
    NegCases = ct:get_config(neg_cases, []),
    Stubs = proplists:get_value(Case, NegCases, []),
    lists:foreach(fun purge_stub/1, Stubs).

end_traces(Case) ->
    TpCases = ct:get_config(tp_cases, []),
    Tps = proplists:get_value(Case, TpCases, []),
    lists:foreach(fun(Tp) -> del_trace(ctp, Tp) end, Tps),
    TplCases = ct:get_config(tpl_cases, []),
    Tpls = proplists:get_value(Case, TplCases, []),
    lists:foreach(fun(Tpl) -> del_trace(ctpl, Tpl) end, Tpls).

%%%-----------------------------------------------------------------------------
%%% Test Cases
%%%-----------------------------------------------------------------------------
normal_case()->
    [{userdata, [{doc, "Tests the public API."}]}].

normal_case(_Conf)->
   {ok,_PID} = ms_app:create_ms({ms1,lai1}),
    %%{ok,_PID} = ms_app:create_ms({ms1,lai1}),
    ok = ms_app:change_state({ms1,turn_on_idle}),
    ok = ms_app:change_lai({ms1,lai2}),
    ok = ms_app:change_lai({ms1,turn_off}).
    

%%%-----------------------------------------------------------------------------
%%% Tracing Util Functions
%%%-----------------------------------------------------------------------------
add_trace(TpFun, {Mod, Fun, Spec}) ->
    dbg:TpFun(Mod, Fun, Spec);
add_trace(TpFun, {Mod, Fun}) ->
    dbg:TpFun(Mod, Fun, ?MATCH_SPEC);
add_trace(TpFun, Mod) ->
    dbg:TpFun(Mod, ?MATCH_SPEC).


del_trace(CtpFun, {Mod, Fun, _Spec}) ->
    dbg:CtpFun(Mod, Fun);
del_trace(CtpFun, {Mod, Fun}) ->
    dbg:CtpFun(Mod, Fun);
del_trace(CtpFun, Mod) ->
    dbg:CtpFun(Mod).

%%%-----------------------------------------------------------------------------
%%% Stub Util Functions
%%%-----------------------------------------------------------------------------
load_stub(Stub, NegTest) ->
    Opts = if NegTest -> [binary, {d, neg_case}]; true ->  [binary] end,
    Erl = atom_to_list(Stub) ++ ".erl",
    ct:print("Compiling ~s with options ~p", [Erl, Opts]),
    {ok, Mod, Bin} = compile:file(filename:join(?STUBS_DIR, Erl), Opts),
    ct:print("Purge default ~p stub", [Mod]),
    code:purge(Mod),
    code:delete(Mod),
    ct:print("Loading new ~p stub", [Mod]),
    Beam = atom_to_list(Mod) ++ code:objfile_extension(),
    {module, Mod} = code:load_binary(Mod, Beam, Bin).


purge_stub(Stub) ->
    ct:print("Purge ~p stub", [Stub]),
    code:purge(Stub),
    code:delete(Stub),
    ct:print("Reloading default ~p stub", [Stub]),
    {module, Stub} = code:load_file(Stub).
