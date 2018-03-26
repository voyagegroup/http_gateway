-module(req_handler).

-export([getdata/1, postdata/1]).

-define(POST_SIZE, 160000).

getdata(Req) ->
    case cowboy_req:method(Req) of
        <<"GET">> ->
            {Qs, _} = cowboy_req:parse_qs(Req),
            Qs;
        _ -> no_getdata
    end.

postdata(Req) ->
    case cowboy_req:method(Req) of
        <<"POST">> ->
            {ok, Qs, _} = cowboy_req:read_urlencoded_body(Req, #{length => ?POST_SIZE}),
            Qs;
        _ -> no_postdata
    end.
