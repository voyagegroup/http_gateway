-module(route_handler).

-export([init/3]).
-export([handle/3]).
-export([terminate/3]).

init(_Transport, Req, []) ->
    {ok, Req, undefined}.
 
handle(Req, State, F) ->
    Res = F(Req),
    {ok, Req2} = make_reply(Res, Req),
    {ok, Req2, State}.

make_reply(Body, Req) ->
  Headers = [{<<"content-type">>, <<"text/plain">>}],
  cowboy_req:reply(200, Headers, Body, Req).

terminate(_Reason, _Req, _State) ->
	  ok.
