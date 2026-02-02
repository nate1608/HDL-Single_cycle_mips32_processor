# ---------------------------------------------------------
# Test: C-Style Function Call with Data Forwarding
# Scenario: main() calls sum(a, b) -> returns 2*(a + b)
# ---------------------------------------------------------

# --- MAIN FUNCTION ---
#START: PC = 0
    addi R1, R0, 10    
    addi R2, R0, 20     
    
    # Argument a = 10; Argument b = 20;


    # Call: (Manual JAL)
    # We want to return to address 16 
    # You must calculate this address based on your instruction count!
    #PC = 2*4 = 8

    addi R31, R0, 16       ; $ra = Return Address
    jump  6                ; Jump to Function: CALC_SUM
    
#STORE_RESULT: PC = 4*4 = 16
    # EXPECTED- $ra = R31 = 16 (return address) and R3 = 2*(a + b)  = 60
    # We store it to check memory later.
    
    sw   R3, 200(R0)    ; Mem[100] = 30
    hlt                 ; Stop


# --- CALC_SUM FUNCTION ---

# Inputs: R1, R2
# Output: R3 = 2*(R1 + R2)
# CALC_SUM: PC = 6*4 = 24

    # Hazard Test: The next instruction uses R1/R2 immediately (Forwarding Check)
    add  R3, R1, R2     ; R3 = 10 + 20 = 30
    add R3, R3, R3      ; R3 = 2*(30)
    
    # Control Hazard Test: Jump Register
    jr   R31            ; Return to Caller (Address 20)
    
    # Delay Slot / Flush Test
    addi R4, R0, 99  ; This instruction should be FLUSHED (Never Executed)