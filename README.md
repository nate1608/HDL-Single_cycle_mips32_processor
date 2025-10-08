# 32-Bit Single-Cycle MIPS Processor in Verilog

This repository contains the RTL design and verification environment for a single-cycle MIPS-like processor. This project was developed to gain a fundamental understanding of computer architecture, including datapath design, control logic, and instruction set implementation. The processor is capable of executing a subset of MIPS instructions, including arithmetic, memory access, and branch operations.

![MIPS Single-Cycle Datapath]

---

## Key Features

- **Single-Cycle Architecture:** Every instruction is executed in a single, long clock cycle.
- **MIPS-like ISA:** Implements a subset of the MIPS instruction set, including R-Type, I-Type, and Branch instructions.
- **Modular Design:** The processor is designed hierarchically with distinct datapath and controller modules for clarity and scalability.
- **Structural Datapath:** The datapath is built from fundamental components like a register file, ALU, memories, and multiplexers.
- **Combinational Controller:** A purely combinational control unit decodes instructions and generates all necessary control signals.
- **Verification Environment:** Includes a Verilog testbench and a Python-based assembler to run custom programs.

---

## Implemented Instruction Set

| Instruction | Type | Opcode | Description |
| :--- | :--- | :--- | :--- |
| `add`, `sub`, `and`, `or`, `slt`, `mul` | R-Type | `000000` - `000101` | Performs the specified ALU operation on two registers and writes the result to a third. |
| `addi`, `subi`, `slti` | I-Type | `001010` - `001100` | Performs an ALU operation on a register and a sign-extended immediate value. |
| `lw` | I-Type | `001000` | Loads a word from data memory into a register. |
| `sw` | I-Type | `001001` | Stores a word from a register into data memory. |
| `beqz`, `bneqz` | I-Type | `001110`, `001101` | Branches to a new address if the specified register is equal/not equal to zero. |
| `hlt` | J-Type | `111111` | Halts the simulation. |

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

The included `factorial.asm` program calculates the factorial of 5. It loads the number 5 from data memory, iteratively multiplies it down to 1, and stores the final result (120) back into data memory. This program tests `lw`, `sw`, `addi`, `mul`, `subi`, and `beqz` instructions, demonstrating the processor's full functionality.
