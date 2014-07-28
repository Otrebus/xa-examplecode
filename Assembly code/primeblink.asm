-- Program switching the LED whenever a new prime number was found
.entry
Main:
dword 0 -- main "object"

.program
.entry
Main_main:
push dword 2
mainLoop:
push dword [$fp-4]
call isPrime
push dword [$fp-4]
push dword 1
add dword
pop dword [$fp-4]
jez byte mainLoop
call toggleLed
jmp mainLoop
ret 0

isPrime:
push dword 2 -- loop var
loopPrime:
push dword [$fp-4] -- loop var
push dword [$fp+4] -- argument
mod dword
jez dword retTrue
push dword [$fp-4]
push dword 1
add dword
pop dword [$fp-4]
push dword [$fp-4]
push dword [$fp+4]
sub dword
jgz dword loopPrime
push byte 0
pop byte [$fp+7]
ret 3
retTrue:
push byte 1
pop byte [$fp+7]
ret 3

.extern
toggleLed:
  "toggleLed"
setLed:
  "setLed"