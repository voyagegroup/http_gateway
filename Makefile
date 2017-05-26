
all:

compile:
	rebar3 compile

test: ct dialyzer 

ct:
	rebar3 ct --logdir test/ct/logs

dialyzer:
	rebar3 dialyzer

xref:
	rebar3 xref
