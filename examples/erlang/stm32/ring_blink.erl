-module(ring_blink).
-export([start/0, blink/1]).

start() ->
    Green = spawn(?MODULE, blink, [{d, 12}]),
    Orange = spawn(?MODULE, blink, [{d, 13}]),
    Red = spawn(?MODULE, blink, [{d, 14}]),
    Blue = spawn(?MODULE, blink, [{d, 15}]),

    Green ! {set_next, Orange},
    Orange ! {set_next, Red},
    Red ! {set_next, Blue},
    Blue ! {set_next, Green},

    Green ! {blink, 500},

    loop().

loop() ->
    loop().

blink(GPIO) ->
    GPIOPort = gpio:open(),
    gpio:set_direction(GPIOPort, GPIO, output),
    blink_loop(GPIOPort, GPIO, nil).

blink_loop(GPIOPort, GPIO, Next) ->
    receive
        {blink, IntervalMs} ->
            do_blink(GPIOPort, GPIO, IntervalMs),
            Next ! blink,
            blink_loop(GPIOPort, GPIO, Next);

        {set_next, Next} ->
            blink_loop(GPIOPort, GPIO, Next)
    end.

do_blink(GPIOPort, GPIO, IntervalMs) ->
    gpio:set_level(GPIOPort, GPIO, 1),
    avm_timer:sleep(IntervalMs),
    gpio:set_level(GPIOPort, GPIO, 0).
