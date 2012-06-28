#!/bin/bash

erl -name esraa@iti.com -pa /home/sherif/Desktop/MSC-MS/msc/ebin/ -pa /home/sherif/Desktop/MSC-MS/hlr/ebin/ -pa /home/sherif/Desktop/MSC-MS/ms/ebin/ -pa /home/sherif/Desktop/MSC-MS/epgsql/ebin/ -eval 'application:start(sasl), application:start(crypto), application:start(public_key), application:start(ssl), application:start(epgsql),application:start(hlr), application:start(msc).' 
