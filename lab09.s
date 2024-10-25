.data               # start of data section
# put any global or static variables here

.section .rodata    # start of read-only data section
# constants here, such as strings
# modifying these during runtime causes a segmentation fault, so be cautious!
myPrintString: .string "The answer is %d\n"

.text               # start of text /code
# everything inside .text is read-only, which includes your code!
.global main        # required, tells gcc where to begin execution

# === functions here ===

main:               # start of main() function
# preamble
pushq %rbp
movq %rsp, %rbp

# === main() code here ===
# set up a = 1
movq $1, %rax       # a = 1 in %rax 
# set up b = 2
movq $2, %rbx       # b = 2 in %rbx
# c = a + b
addq %rbx, %rax     # c = a + b in %rax

# printf("The answer is %d\n")
# 1. save any caller saved registers
#       a. place in callee saved registers %r12 - %r15
#       b. OR place items on stack
movq %rax, %r12 # c in %r12
pushq %rax      # c in stack
#-----pushq %rax in case of emergency-----
# 2. set up registers, args in %rdi, %rsi
movq $myPrintString, %rdi #pointer to string in %rdi
movq %rax, %rsi
# 3. 0 in %rax, no floating point registers
movq $0, %rax
xorq %rax, %rax
# 4. call function
call printf

# restore c in %rax
popq %rax   #c in rax
#-----popq %rax in case of emergency-----

# NOTE: sometimes printf may have an error because of the stack pointer may not start off aligned
#       so to solve this is to pushq %rax and popq %rax twice


# clean up and return
movq $0, %rax       # place return value in rax
leave               # undo preamble, clean up the stack
ret                 # return
