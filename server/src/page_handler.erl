-module(page_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2, terminate/3]).

-record(state, {}).

init(_, Req, _Opts) ->
        {ok, Req, #state{}}.

handle(Req, State=#state{}) ->
        {Method, _} = cowboy_req:method(Req),
        HasBody = cowboy_req:has_body(Req),
        {ok, Req2} = respond(Method, HasBody, Req),
        {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
        ok.

respond(<<"GET">>, false, Req) ->
        ExampleJSON = json:from_binary(<<"{\"library\": \"json\", \"awesome\": true,
        \"list\": [{\"a\": 1}, {\"b\": 2}, {\"c\": 3} ]}">>),
        cowboy_req:reply(200,
                [{<<"content-type">>, <<"application/json">>}],
                ExampleJSON,
                Req);
respond(<<"POST">>, true, Req) ->
        cowboy_req:reply(200,
                [{<<"content-type">>, <<"text/html">>}],
                <<"POSTING">>,
                Req);
respond(<<"POST">>, false, Req) ->
        cowboy_req:reply(400,
                [{<<"content-type">>, <<"text/html">>}],
                <<"TEST">>,
                Req).