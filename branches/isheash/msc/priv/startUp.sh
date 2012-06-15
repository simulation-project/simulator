#!/bin/bash

erl -name esraa@iti.com -pa /home/sony/GP/simulator/branches/isheash/msc/ebin/ -pa /home/sony/GP/simulator/branches/isheash/hlr/ebin/ -pa /home/sony/GP/simulator/branches/isheash/ms/ebin/ -pa /home/sony/GP/simulator/branches/isheash/epgsql/ebin/ -eval 'application:start(sasl), application:start(crypto), application:start(public_key), application:start(ssl), application:start(epgsql),application:start(hlr), application:start(msc).' 
