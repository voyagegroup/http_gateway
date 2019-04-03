-module(req_handler).

-export([getdata/1, postdata/1, header/2]).

-define(APP_NAME, http_gateway).
-define(POST_SIZE, 320000).

getdata(Req) ->
    case cowboy_req:method(Req) of
        <<"GET">> ->
            Qs = cowboy_req:parse_qs(Req),
            Qs;
        _ -> no_getdata
    end.

postdata(Req) ->
    case cowboy_req:method(Req) of
        <<"POST">> ->
            {ok, Qs, _} = cowboy_req:read_urlencoded_body(Req, #{length => get_postsize()}),
            Qs;
        _ -> no_postdata
    end.

get_postsize() ->
    case application:get_env(?APP_NAME, postsize) of
        {ok, Postsize} -> Postsize;
        _ -> ?POST_SIZE
    end.

-spec header(binary(), cowboy_req:req()) -> binary() | undefined.
header(Name, Req) ->
    cowboy_req:header(Name, Req).

