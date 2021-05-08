SYSEXIT = 1
SYSWRITE = 4
STDOUT = 1
EXIT_SUCCESS = 0
SYSREAD = 3
STDIN = 0
BUFSIZE = 100 #max bufor

.global _start  #directive tells where to start the program

.data #directive declares space in memory
BUF: .space BUFSIZE

msg: .ascii "Write a message: \n"
msgLen = . - msg

msg2: .ascii "Coded message: "
msg2Len = . - msg2

newLine: .ascii "\n"
newLineLen = . - newLine

.text #directive starts the actual program code

_start:

mov $SYSWRITE, %eax   #called function
mov $STDOUT, %ebx     #output
mov $msg, %ecx        #starting address of the string
mov $msgLen, %edx     #string length
int $0x80             #system interrupt

mov $SYSREAD, %eax    #called function
mov $STDIN, %ebx      #input
mov $BUF, %ecx        #starting address of the string
mov $BUFSIZE, %edx    #string length
int $0x80

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $msg2, %ecx
mov $msg2Len, %edx
int $0x80

movl $BUF, %eax       #message from console
movl $BUFSIZE, %ecx   #message length
xor %ebx, %ebx        #zero

begin:
cmp $0, %ecx          #compare message length to zero
jz exit               #jump to exit if there is no message
movb (%eax), %bl      #copy address from eax to bl

upper:
cmpb $65, %bl         #compare bl to 65
jb not_a_letter       #if below 65 jump to not_a_letter
cmpb $77, %bl         #if above or equal to 65 compare bl to 77
jbe plus              #if below or equal to 77 jump to plus 13
cmpb $90, %bl         #if above 77 compare bl to 90
jbe minus             #if below or equal to 90 jump to minus 13
jmp lower             #if above 90 jump to lower

lower:
cmpb $97, %bl         #compare bl to 97
jb not_a_letter       #if below 97 jump to not_a_letter
cmpb $109, %bl        #if above or equal to 97 compare bl to 109
jbe plus              #if below or equal to 109 jump to plus 13
cmpb $122, %bl        #if above 109 compare bl to 122
jbe minus             #if below or equal to 122 jump to minus
jmp not_a_letter      #if above 122 jump to not_a_letter

plus:
addb $13, %bl         #add 13 to bl
movb %bl, (%eax)      #copy new value to address in eax
jmp not_a_letter      #jump to not_a_letter

minus:
subb $13, %bl         #substract 13 from bl
movb %bl, (%eax)      #copy new value to address in eax
jmp not_a_letter      #jump to not_a_letter

not_a_letter:
addl $1, %eax         #increment memory pointer
subl $1, %ecx         #decrement length
jmp begin             #jump to the beginning

exit:

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $BUF, %ecx
mov $BUFSIZE, %edx
int $0x80

mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $newLine, %ecx
mov $newLineLen, %edx
int $0x80

mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
