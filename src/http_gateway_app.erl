-module(http_gateway_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-define(APP_NAME, http_gateway).
-define(DEFAULT_PORT, 8887).

%% ===================================================================
%% Application callbacks
%% ===================================================================

-spec start( application_controller:start_type(), StartArgs::term() ) -> {ok, pid()} | {ok, pid(), State::term()} | {error, Reason::term()}.
start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
          {'_', get_routes()}
    ]),
    cowboy:start_http(get_name(), 100, [{port, get_port()}], [
          {env, [{dispatch, Dispatch}]}
    ]),
    http_gateway_sup:start_link().

-spec stop(State::term()) -> ok.
stop(_State) ->
    cowboy:stop_listener(get_name()),
    ok.

-spec get_name() -> atom().
get_name() ->
    case application:get_env(?APP_NAME, name) of
        {ok, Name} -> Name;
        _ -> http
    end.

-spec get_routes() -> [term()].
get_routes() ->
    case application:get_env(?APP_NAME, routes) of
        {ok, Routes} -> Routes;
        _ -> []
    end.

-spec get_port() -> number().
get_port() ->
    case application:get_env(?APP_NAME, port) of
        {ok, Port} -> Port;
        _ -> ?DEFAULT_PORT
    end.
