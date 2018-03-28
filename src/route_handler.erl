-module(route_handler).

-export([init/2]).
-export([handle/3]).
-export([terminate/3]).

init(Req0, State) ->
    Req = cowboy_req:reply(200, #{
        <<"content-type">> => <<"text/plain">>
    }, <<"Hello">>, Req0),
    {ok, Req, State}.

handle(Req, State, F) ->
    Res = F(Req),
    Req2 = make_reply(Res, Req),
    {ok, Req2, State}.

make_reply(Body, Req) ->
    Headers = #{<<"content-type">> => <<"text/plain">>},
    cowboy_req:reply(200, Headers, Body, Req).

terminate(_Reason, _Req, _State) ->
    ok.
