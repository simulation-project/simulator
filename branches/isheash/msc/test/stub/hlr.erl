-module(hlr).
-compile([export_all]).

check_imsi(IMSI,SPC)->
    ok;
check_imsi(x,SPC) ->
    false .
update_location({6, 1, IMSI, VLR, GT},SPC)->
   code:add_path("../../ebin"),
    msc_app:insert_subscriber_data(IMSI,info,spc1 ),
    ok.
    