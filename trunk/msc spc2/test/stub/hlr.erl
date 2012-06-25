-module(hlr).
-compile([export_all]).

check_imsi(x,SPC) ->
    false ;
check_imsi(IMSI,SPC)->
    ok.



imsiExist(SPC,IMSI) ->
	ok.


send_routing_info('010001233333', '3-100' ,'gt1')->
	msc_app:receive_PRN({6, 5, '60202124555567', 'spc2'}),
	msc_app:result_SRI({6, 7, '2', 'spc1'}).
