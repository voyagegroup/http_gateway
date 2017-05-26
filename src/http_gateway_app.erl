-module(http_gateway_app).

-behaviour(application).

%% API
-export([start/0]).

%% Application callbacks
-export([start/2, stop/1]).

-define(APP_NAME, http_gateway).
-define(DEFAULT_PORT, 8887).

%% ===================================================================
%% API callbacks
%% ===================================================================

start() ->
    application:start(http_gateway).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
          {'_', get_routes()}
    ]),
    cowboy:start_http(get_name(), 100, [{port, get_port()}], [
          {env, [{dispatch, Dispatch}]}
    ]),
    http_gateway_sup:start_link().

stop(_State) ->
    cowboy:stop_listener(get_name()),
    ok.

get_name() ->
    case application:get_env(?APP_NAME, name) of
        {ok, Name} -> Name;
        _ -> http
    end.

get_routes() ->
    case application:get_env(?APP_NAME, routes) of
        {ok, Routes} -> Routes;
        _ -> []
    end.

get_port() ->
    case application:get_env(?APP_NAME, port) of
        {ok, Port} -> Port;
        _ -> ?DEFAULT_PORT
    end.
