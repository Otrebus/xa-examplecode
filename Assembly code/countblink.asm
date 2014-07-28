-- Program switching the LED whenever a counter reaches some value, uses ASYNC to increase count
.entry
Main:
dword 0 -- main "object"
CounterObject:
dword 0
CounterObject_count:
dword 100 -- count
CounterObject_startCount:
dword 100

.program
.entry
Main_main:
push dword 900
push CounterObject_startCounting
push CounterObject
sync
ret 0

CounterObject_startCounting:
push dword [$fp+4] -- get the argument from the top of the stack
pop dword [CounterObject_count] -- update counterobject count variable
push dword [$fp+4]
pop dword [CounterObject_startCount]
push CounterObject_inc -- prepare to async the inc method
push CounterObject
push dword 1000
push dword 10000
push byte 0
async
ret 4

CounterObject_inc:
push dword [CounterObject_count] -- load count var
push dword 1
add dword -- add 1 to count var
pop dword [CounterObject_count] -- update counterobject count variable
push dword [CounterObject_count]
push dword 1000
sub dword
jnez dword notoggle
call toggleLed
push dword [CounterObject_startCount]
pop dword [CounterObject_count]

notoggle:
push CounterObject_inc
push CounterObject
push dword 1000
push dword 10000
push byte 0
async
ret 0

.extern
toggleLed:
  "toggleLed"
setLed:
  "setLed"