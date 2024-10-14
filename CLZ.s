.data
    test_cases:     .word 0x00000000, 0x00080000, 0x80000000
    str1:           .string "Test case "
    str2:           .string ": leading zeros = "
    str3:           .string "\n"
    

.text
.globl main

main:
    li      t0, 0              # i = 0
    la      t1, test_cases     # load address of test_cases

loop:
    addi    t2, t2, 3          # t2 = 3
    bge     t0, t2, end_loop   # if i >= 3, exit loop

    slli    t2, t0, 2          # calculate address offset
    add     t3, t1, t2         # calculate address of test_cases[i]
    lw      t2, 0(t3)          # t2 = test_cases[i]

    jal     ra, clz            # call clz function
    mv      t3, a0             # store result in t3

    jal     ra, print          # printf()  

    addi    t0, t0, 1          # i++
    j       loop               # repeat loop

end_loop:
    li      a0, 0              # return 0
    li      a7, 10             # Exit code
    ecall  

clz:
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
    ret
    
print:
    la      a0, str1           # load address of str1
    li      a7, 4              # print string syscall
    ecall                      # print string syscall
       
    addi    a0, t0, 1          # load number of test case
    li      a7, 1              # print int syscall
    ecall                      # print int syscall

    la      a0, str2           # load address of str2
    li      a7, 4              # print string syscall
    ecall                      # print string syscall

    addi    a0, t3, 0          # load answer of test case
    li      a7, 1              # print int syscall
    ecall                      # print int syscall

    la      a0, str3           # load address of str3
    li      a7, 4              # print string syscall
    ecall                      # print string syscall
    
    ret