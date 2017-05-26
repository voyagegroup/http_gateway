
all:

compile:
	rebar3 compile

test: ct

ct:
	rebar3 ct --logdir test/ct/logs
