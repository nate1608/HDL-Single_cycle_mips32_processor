# Factorial of 5 program
# R1 will hold the number n (initially 5)
# R2 will hold the result (the factorial)

# Instruction at PC=0: LW R1, 200(R0) -> Load n=5 into R1 , PC=0
lw R1, 200(R0)

# Instruction at PC=4: ADDI R2, R0, 1 -> Initialize result=1 in R2, PC=1
addi R2, R0, 1

#LOOP_START
# Instruction at PC=12: MUL R2, R2, R1 -> result = result * n, PC=2
mul R2, R2, R1

# Instruction at PC=16: SUBI R1, R1, 1 -> n = n - 1, PC=3
subi R1, R1, 1

# Instruction at PC=20: BNEQZ R1, -2 -> back to LOOP_START: PC=4, NPC=4-2=2
bneqz R1, -2

# Instruction at PC=24: END: SW R2, 198(R0) -> Store final result, PC=5
sw R2, 198(R0)

# Instruction at PC=28: HLT, PC=6
hlt