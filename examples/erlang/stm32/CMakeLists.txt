##
## Copyright (c) 2019 Riccardo Binetti <rbino@gmx.com>
##

project(examples_erlang_stm32)

include(BuildErlang)

pack_runnable(ring_blink ring_blink eavmlib estdlib)
