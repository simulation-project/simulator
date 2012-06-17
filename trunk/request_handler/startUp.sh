#!/bin/bash

erl -sname server@localhost -pa ../msc/ebin/ -pa ../hlr/ebin/ -pa ../ms/ebin/ -pa ../epgsql/ebin/ -pa ebin/ -eval 'application:start(sasl), application:start(crypto), application:start(public_key), application:start(ssl), application:start(epgsql),application:start(hlr), application:start(msc), application:start(request_handler), application:start(ms).' 
