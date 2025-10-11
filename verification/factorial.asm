# Factorial of 5 program
# R1 will hold the number n (initially 5)
# R2 will hold the result (the factorial)

# Instruction at PC=0: LW R1, 200(R0) -> Load n=5 into R1
lw R1, 200(R0)

# Instruction at PC=4: ADDI R2, R0, 1 -> Initialize result=1 in R2
addi R2, R0, 1

# Instruction at PC=8: LOOP_START: BEQZ R1, END -> If n=0, jump to end
# Offset is 3 instructions from PC+4 (3*4 = 12 bytes)

# Instruction at PC=12: MUL R2, R2, R1 -> result = result * n
mul R2, R2, R1

# Instruction at PC=16: SUBI R1, R1, 1 -> n = n - 1
subi R1, R1, 1

# Instruction at PC=20: BNEQZ R0, -5 -> Unconditional jump back to LOOP_START
# Note: R0 is always 0, so BNEQZ R0 is like a 'jump'
# Offset is -5 instructions from PC+4.
bneqz R1, -3

# Instruction at PC=24: END: SW R2, 198(R0) -> Store final result
sw R2, 198(R0)

# Instruction at PC=28: HLT
hlt