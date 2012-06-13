#!/bin/bash

erl -name esraa@iti.com -pa /home/sherif/Desktop/msc/ebin/ -pa /home/sherif/Desktop/epgsql/ebin/ -eval 'application:start(sasl), application:start(crypto), application:start(public_key), application:start(ssl), application:start(epgsql)' 
