%%%-------------------------------------------------------------------------%%%
%%% Description : Eon - 10k ships battle server                             %%%
%%% Version     : 0.0.1/flying dot                                          %%%
%%% File        : dot.erl                                                   %%%
%%% Description : single dot flying circles using ESDL2                     %%%
%%% Copyright   : H. Diedrich                                               %%%
%%% Author      : H. Diedrich <hd2010@eonblast.com>                         %%%
%%% License     : MIT                                                       %%%
%%% Created     : 21 Apr 2014                                               %%%
%%% Changed     : 13 Jun 2014                                               %%%
%%%-------------------------------------------------------------------------%%%

-module(dot).
-export([run/0]).

run() ->
    spawn_opt(fun init/0, [{scheduler, 0}]).

init() ->
    %% setup sdl, window and renderer
    ok = sdl:start([video]),
    ok = sdl:stop_on_exit(),
    {ok, Window} = sdl_window:create("Dot", 10, 10, 500, 500, []),
    {ok, Renderer} = sdl_renderer:create(Window, -1, [accelerated, present_vsync]),
    %% start animaton
    loop(#{window=>Window, renderer=>Renderer, t=>0}).

%% animation loop
loop(State) ->
    events_loop(),
    loop(render(State)).

%% check for termination
events_loop() ->
    case sdl_events:poll() of
        false -> ok;
        #{type:=quit} -> terminate();
        _ -> events_loop()
    end.

%% render one frame
render(#{renderer:=Renderer, t:=T}=State) ->
    %% clear screen
    ok = sdl_renderer:set_draw_color(Renderer, 0,0,0,0),
    ok = sdl_renderer:clear(Renderer),
    %% draw dot
    X = erlang:round(250 + 100 * math:sin(T/250) * (math:cos(T/100) + math:cos(T/10))),
    Y = erlang:round(250 + 100 * math:sin(T/250) * (math:sin(T/100) + math:sin(T/10))),
    ok = sdl_renderer:set_draw_color(Renderer, 255, 255, 255, 255),
    ok = sdl_renderer:draw_point(Renderer, #{x=>X, y=>Y}),
    %% render
    ok = sdl_renderer:present(Renderer),
    %% progress timeline
    State#{t=>T + 1}.

terminate() ->
    init:stop(),
    exit(normal).
