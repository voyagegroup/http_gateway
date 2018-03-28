%%%-------------------------------------------------------------------
%% @doc http_gateway public API
%% @end
%%%-------------------------------------------------------------------

-module(http_gateway_app).

-behaviour(application).

%% Application callbacks
-export([start/0]).
-export([start/2, stop/1]).

-define(APP_NAME, http_gateway).
-define(DEFAULT_PORT, 8887).

%%====================================================================
%% API
%%====================================================================

start() ->
    application:start(http_gateway).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
          {'_', get_routes()}
    ]),
    cowboy:start_clear(http, [{port, get_port()}], #{
          env => #{dispatch => Dispatch}
    }),
    http_gateway_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.


%%====================================================================
%% Internal functions
%%====================================================================
get_routes() ->
    case application:get_env(?APP_NAME, routes) of
        {ok, Routes} -> Routes;
        _ -> [{"/", route_handler, []}]
    end.

get_port() ->
    case application:get_env(?APP_NAME, port) of
        {ok, Port} -> Port;
        _ -> ?DEFAULT_PORT
    end.
