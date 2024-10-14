.data
    test_cases:     .word 11, 3, 19, 0, 1, 13
    str1:           .string "Test case : "
    str2:           .string " => Quotient: "
    str3:           .string ", Remainder: "
    str4:           .string "\n"
    str5:           .string " => Error: Divided by zero!\n"

.text
.globl main

main:
    la   t0, test_cases        # load address of test_cases
    addi t1, x0, 0             # i = 0

loop:
    addi t2, x0, 3             # loop count (3 test cases)
    bge  t1, t2, end_loop      # if i >= 3, exit loop
    
    # load dividend, divisor into t3, t4
    slli t5, t1, 3             # t5 = i * 8 (8 bytes for each test case)
    add  t5, t0, t5            # address of the current test case
    lw   t3, 0(t5)             # load dividend into t3
    lw   t4, 4(t5)             # load divisor into t4    
    
    # bitwise_division
    mv a0, t3
    mv a1, t4
    jal ra, bitwise_division
    
    mv t5, a0                  # t5 = quotient
    mv t6, a1                  # t6 = remainder
    jal ra, print 
  
    addi t1, t1, 1             # i++
    j loop

end_loop:
    li      a0, 0              # return 0
    li      a7, 10             # Exit code
    ecall

bitwise_division:
    # store t1 into stack
    addi sp, sp, -8            # allocate 8 bytes
    sw   ra, 0(sp)             # store ra
    sw   t1, 4(sp)             # store t1
    
    mv t1, a0                  # t1 = dividend = remainder
    mv t2, a1                  # t2 = divisor
    addi t3, x0, 0             # initialize quotient, t3 = 0
    beq t2, x0, zero_division   # if (divisor == 0), return 
    
    # call clz
    mv a0, t1                  # a0 = dividend
    jal ra, clz                #
    mv t4, a0                  # t4 = clz(dividend)
    
    addi t5, x0, 31            # t5 = 31
    sub t4, t5, t4             # t4 = 31 - clz(dividend)  
        
division_loop:
    blt t4, x0, end_division   # check if i >= 0
    srl t5, t1, t4             # t5 = remainder >> i
    bge t5, t2, update         # if ((remainder >> i) >= divisor)
    addi t4, t4, -1            # i--
    j division_loop
    
update:
    sll t5, t2, t4             # t5 = divisor << i
    sub t1, t1, t5             # remainder -= (divisor << i)
    addi t5, x0, 1             # t5 = 1
    sll t5, t5, t4             # t5 = 1 << i
    or t3, t3, t5              # quotient |= (1 << i)
    addi t4, t4, -1            # i--
    j division_loop

zero_division:
    addi a1, x0, -1
    # load t1 from stack
    lw   t1, 4(sp)             # load t1
    lw   ra, 0(sp)             # load ra
    addi sp, sp, 8             # release 8 bytes
    ret

end_division:
    mv      a0, t3             # a0 = quotient
    mv      a1, t1             # a1 = remainder
    # load t1 from stack
    lw   t1, 4(sp)             # load t1
    lw   ra, 0(sp)             # load ra
    addi sp, sp, 8             # release 8 bytes
    ret

clz:
    # store into stack
    addi sp, sp, -8           # allocate 8 bytes
    sw   t2, 0(sp)             # store t2
    sw   t3, 4(sp)             # store t3
    
    mv      t2, a0             #
    li      t3, 0              # count = 0
    li      t4, 31             # i = 31

count_loop:
    bltz    t4, return_clz     # if i < 0, return count
    addi    t5, x0, 1
    sll     t5, t5, t4         # t5 = 1 << i
    and     t5, t2, t5         # value & (1U << i)
    beqz    t5, update_count   # if result == 0, count++
    j       return_clz         # else, exit loop

update_count:
    addi    t3, t3, 1          # count++
    addi    t4, t4, -1         # i--
    j       count_loop         # repeat count loop

return_clz:
    mv      a0, t3             # return count in a0
    # load from stack
    lw   t3, 4(sp)             # load t3
    lw   t2, 0(sp)             # load t2
    addi sp, sp, 8            # release 8 bytes
    ret

print:
    blt t6, x0, print_error    # jump to print_error
    
    la      a0, str1           # load address of str1
    li      a7, 4              # print string syscall
    ecall                      # print string syscall
    
    addi    a0, t1, 1          # load number of test case
    li      a7, 1              # print int syscall
    ecall                      # print int syscall
    
    la      a0, str2           # load address of str2
    li      a7, 4              # print string syscall
    ecall                      # print string syscall
       
    addi    a0, t5, 0          # load quotient
    li      a7, 1              # print int syscall
    ecall                      # print int syscall

    la      a0, str3           # load address of str3
    li      a7, 4              # print string syscall
    ecall                      # print string syscall

    addi    a0, t6, 0          # load remainder
    li      a7, 1              # print int syscall
    ecall                      # print int syscall

    la      a0, str4           # load address of str4
    li      a7, 4              # print string syscall
    ecall                      # print string syscall
    
    ret
    
print_error:
    la      a0, str1           # load address of str1
    li      a7, 4              # print string syscall
    ecall                      # print string syscall
    
    addi    a0, t1, 1          # load number of test case
    li      a7, 1              # print int syscall
    ecall                      # print int syscall
    
    la      a0, str5           # load address of str5
    li      a7, 4              # print string syscall
    ecall                      # print string syscall
    
    ret