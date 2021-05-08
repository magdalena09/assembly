SYSEXIT = 1
EXIT_SUCCES = 0

.data
#masks
r_n: .short 0x03F #round to the nearest
r_d: .short 0x43F #round down
r_u: .short 0x83F #round up
r_z: .short 0xC3F #round to zero

msg1: .asciz "Write an operation: \n 1. Addition \n 2. Substraction \n 3. Division \n 4. Multiplication \n"
msg2: .asciz "Write a rounding mode: \n 1. Nearest \n 2. Down \n 3. Up \n 4. Zero \n"
choice: .asciz "%d"
msg3: .asciz "Write first number: "
first: .double 0.0
f: .asciz "%f"
msg4: .asciz "Write second number: "
error_msg: .asciz "Wrong input. \n"
second: .double 0.0
s: .asciz "%f"
result: .asciz "%f\n"
operation: .zero 1
round: .zero 1

.text

.globl main

main:
  push $msg1            #print choice of operation
  call printf
  add $4, %esp

  pushl $operation      #read 1,2,3,4
  push $choice
  call scanf
  addl $8, %esp

  push $msg2            #print choice of rounding
  call printf
  add $4, %esp

  pushl $round          #read 1,2,3,4
  push $choice
  call scanf
  addl $8, %esp

round_mode:             #compare and jump to right rounding
 cmpb $1, round
 je nearest
 cmpb $2, round
 je down
 cmpb $3, round
 je up
 cmpb $4, round
 je zero

 jmp error
#load to control word and jump
nearest:
  fldcw r_n
  jmp read_num
down:
  fldcw r_d
  jmp read_num
up:
  fldcw r_u
  jmp read_num
zero:
  fldcw r_z
  jmp read_num

read_num:               #read two numbers
  push $msg3
  call printf
  add $4, %esp

  pushl $first
  push $f
  call scanf
  addl $8, %esp

  push $msg4
  call printf
  add $4, %esp

  pushl $second
  push $s
  call scanf
  addl $8, %esp
#compare and jump to chosen operation
  cmpb $1, operation
  je addfpu
  cmpb $2, operation
  je subfpu
  cmpb $3, operation
  je divfpu
  cmpb $4, operation
  je mulfpu

  jmp error
#operations
addfpu:
  flds first
  fadds second
  jmp final

subfpu:
  flds first
  fsubs second
  jmp final

divfpu:
  flds first
  fdivs second
  jmp final

mulfpu:
  flds first
  fmuls second

final:
  subl $8, %esp
  fstpl (%esp)
  push $result
  call printf
  add $12, %esp
  ret

error:
  pushl $error_msg
  call printf
  mov $SYSEXIT, %eax
  mov $EXIT_SUCCES, %ebx
  int $0x80
