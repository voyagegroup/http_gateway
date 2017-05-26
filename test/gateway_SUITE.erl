-module(gateway_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0, init_per_testcase/2, end_per_testcase/2]).
-export([echo_post_tests/1]).

all() -> [echo_post_tests].

init_per_testcase(echo_post_tests, Config) ->
    Name = make_ref(),
    application:set_env(http_gateway, name, Name),
    application:set_env(http_gateway, port, 0),
    application:set_env(http_gateway, routes, [{"/post", test_post_handler, []}]),
    application:ensure_all_started(http_gateway),
    application:ensure_all_started(hackney),

    Port = ranch:get_port(Name),
    [ {port, Port} | Config ].

end_per_testcase(echo_post_tests, Config) ->
    application:stop(http_gateway),
    Config.

echo_post_tests(Config) ->
    Port = proplists:get_value(port, Config),
    Url = io_lib:format("http://0.0.0.0:~p/post", [Port]),
    Msg = <<"hoge">>,
    Body = {form, [{<<"echo">>, Msg}]},
    {ok, 200, _, Res} = hackney:request(post, Url, [], Body),
    {ok, Msg} = hackney:body(Res).
