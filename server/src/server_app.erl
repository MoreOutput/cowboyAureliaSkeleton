%% @private
-module(server_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/index.html", cowboy_static, {priv_file, server, "index.html"}},
			{"/[...]", cowboy_static, {priv_dir, server, ""}},
			{"/page", page_handler, []}	
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 9000}], [
		{env, [{dispatch, Dispatch}]}
	]),
	server_sup:start_link().

stop(_State) ->
	ok.
