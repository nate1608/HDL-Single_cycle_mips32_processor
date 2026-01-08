# 32-Bit MIPS Processor: Single-Cycle & 5-Stage Pipeline

This repository contains the RTL design and verification of a 32-bit MIPS-based processor. It serves as a comprehensive study of computer architecture, evolving from a functional **Single-Cycle** implementation to a high-performance **5-Stage Pipelined** microarchitecture.

---

## Project Architecture

This project is divided into two major microarchitectural implementations:

### 1. Single-Cycle Core (Completed & Verified)
The baseline implementation where every instruction is executed in a single, long clock cycle.
- **Status:**  Verified
- **Features:** Complete Datapath & Combinational Control Unit.
- **Verification:** Validated via custom factorial assembly program.

### 2. 5-Stage Pipelined Core (Active Development)
An advanced implementation designed to improve instruction throughput by splitting execution into 5 stages: **IF | ID | EX | MEM | WB**.
- **Status:**  In Progress
- **Key Features:**
  - **Inter-Stage Registers:** Synchronized buffers (`IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB`) to isolate critical paths.
  - **Distributed Control:** Control signals are decoded in ID and propagated through pipeline registers.
  - **Hazard Handling:** (See Roadmap below).

---

## 🛠️ Implementation Details

### Instruction Set Architecture (ISA)
Both cores support a subset of the MIPS32 ISA, allowing for arithmetic, logic, memory, and control flow operations.

| Instruction | Format | Opcode | Description |
| :--- | :--- | :--- | :--- |
| `add`, `sub`, `and`, `or`, `slt`, `mul` | R-Type | `000000` - `000101` | Register-to-Register ALU operations. |
| `addi`, `subi`, `slti` | I-Type | `001010` - `001100` | Immediate ALU operations. |
| `lw` | I-Type | `001000` | Load Word from Memory. |
| `sw` | I-Type | `001001` | Store Word to Memory. |
| `beqz`, `bneqz` | Branch | `001110`, `001101` | Branch Equal/Not Equal Zero. |
| `hlt` | J-Type | `111111` | Halt Simulation. |

### Pipeline Hazard Management (Roadmap)
The pipeline architecture is currently being upgraded to handle execution hazards.
- [x] **Datapath Slicing:** Pipeline registers implemented and instruction flow verified.
- [ ] **Data Hazards:** Forwarding Unit (Bypassing) to resolve RAW dependencies. *[Coming Soon]*
- [ ] **Control Hazards:** Branch prediction/flushing logic. *[Coming Soon]*
- [ ] **Load-Use Hazards:** Stalling logic implementation. *[Coming Soon]*

---
## How to Run the Simulation

To verify the functionality of the processor, follow these steps:

1.  **Write a Program:** Write a MIPS assembly program using the supported instructions and save it as `program.asm`. An example factorial program is provided in the `verification/programs/` directory.

2.  **Assemble the Program:** Use the provided Python assembler to convert your assembly code into 32-bit hexadecimal machine code. This will generate a `program.hex` file.
    ```bash
    python verification/assembler.py
    ```

3.  **Run the Simulation:** Launch your Verilog simulator (e.g., Xilinx Vivado, ModelSim) and run the `testbench.v` file. The testbench is configured to automatically load `program.hex` into the instruction memory at the start of the simulation.

4.  **Check the Results:** The testbench will monitor and display the contents of the register file and data memory, allowing you to verify that your program executed correctly.

---

## Example Program: Factorial of 5

The included an default `program.asm` program calculates the factorial of 5. It loads the number 5 from data memory, iteratively multiplies it down to 1, and stores the final result (120) back into data memory. This program tests `lw`, `sw`, `addi`, `mul`, `subi`, and `beqz` instructions, demonstrating the processor's full functionality.

## 📂 Repository Structure

```text
/rtl
  ├── /single_cycle    # The verified baseline core
  ├── /pipeline        # The 5-stage pipelined core (Active Dev)
  └── /common          # Shared modules (ALU, Register File)
/verification
  ├── assembler.py     # Python assembler for MIPS -> Hex
  ├── program.asm      # Assembly source code
  └── test_bench.v     # Verilog simulation environment-


