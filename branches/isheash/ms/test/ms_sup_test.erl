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
%%% @author Marwa ElShahed <marwa.elshahed@hotmail.com>
%%%         [http://www.iti.gov.eg/]
%%% @end
-module(ms_sup_test).
-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

start_link_test()->
    ?_assert(ms_sup:start_link() == {ok,pid}).

