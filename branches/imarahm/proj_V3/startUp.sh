#! /bin/bash

erl -pa ./ms/ebin -pa./ms/test/stubs -pa ./request_handler/ebin -sname server@localhost
