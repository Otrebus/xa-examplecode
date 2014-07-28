-- Program controlling the speed of a blinking led through uart strings like "500"

.entry
Main:
  dword 0 -- main "object"
Blinker:
  dword 0
Blinker_halfperiod:
  dword 1000000 -- half-period
UartHandler:
  dword 0
UartSender:
  dword 0

msg:
  "Ok!"

.program
.entry
Main_main:
  push UartHandler_handleMsg
  push UartHandler
  call setUartCallback
  push Blinker_blink
  push Blinker
  sync
  ret 0

UartHandler_handleMsg:
  push 6
  push dword 0
  pop dword [$fp-6] -- set sum to 0

  push byte [$fp+4]
  pop byte [$fp-1] -- radix counter

  push byte 0
  pop byte [$fp-2]  -- index counter

handleMsgLoop:
  push byte 1
  push byte [$fp-1]
  sub byte
  pop byte [$fp-1]

  push byte 0 --
  push word 0 -- prepare to convert byte (character) to dword

  push word [$fp+5] 
  push byte 0
  push byte [$fp-2]
  add word          -- add index to pointer

  push byte          
  call asciitonum -- together with the previously pushed 0's, this is a dword
  push byte [$fp-1]
  push 3 -- make room for return value
  call pow10
  mul dword
  push dword [$fp-6]
  add dword
  pop dword [$fp-6]  -- update total sum

  push byte [$fp-1]
  jez byte end

  push byte [$fp-2]
  push byte 1
  add byte
  pop byte [$fp-2]

  jmp handleMsgLoop

end:
  push dword [$fp-6]
  push dword 1000
  mul dword
  push Blinker_setperiod
  push Blinker
  sync

  push UartSender_send
  push UartSender
  push dword 0
  push dword 0
  push byte 0
  async
  ret 3

UartSender_send:
  push msg
  push byte 3
  call uartTransmit
  ret 0

Blinker_setperiod:
  push dword [$fp+4]
  pop dword [Blinker_halfperiod]
  ret 4

Blinker_blink:
  call toggleLed
  push Blinker_blink
  push Blinker
  push dword 1000
  push dword [Blinker_halfperiod]
  push byte 0
  async
  ret 0

pow10:
  push byte [$fp+7]
  jnez byte pow10_cont
  push dword 1
  pop dword [$fp+4]
  ret 0

pow10_cont:
  push byte 1
  push byte [$fp+7]
  sub byte
  push 3
  call pow10
  push dword 10
  mul dword
  pop dword [$fp+4]
  ret 0

asciitonum:
  push byte 48
  push byte [$fp+4]
  sub byte
  pop byte [$fp+4]
  ret 0

.extern
toggleLed:
  "toggleLed"
setLed:
  "setLed"
setUartCallback:
  "setUartCallback"
uartTransmit:
  "uartTransmit"