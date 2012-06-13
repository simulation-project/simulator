#!/bin/bash

erl -name marwa@iti.com -pa /home/sherif/Desktop/ms/ebin/ -pa /home/sherif/Desktop/msc/ebin/ -eval 'application:start(sasl)' 
