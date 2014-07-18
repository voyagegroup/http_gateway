-module(req_handler).

-export([getdata/1, postdata/1]).

-define(POST_SIZE, 160000).

getdata(Req) ->
    case cowboy_req:method(Req) of
        {<<"GET">>, _} ->
            {Qs, _} = cowboy_req:qs_vals(Req),
            Qs;
        _ -> no_getdata
    end.

postdata(Req) ->
    case cowboy_req:method(Req) of
        {<<"POST">>, _} ->
            {ok, Qs, _} = cowboy_req:body_qs(Req, [{length, ?POST_SIZE}]),
            Qs;
        _ -> no_postdata
    end.
