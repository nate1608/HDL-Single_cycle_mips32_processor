import re

# --- Configuration ---
# Opcodes as defined in your control_path module
OPCODES = {
    'add':   '000000', 'sub':   '000001', 'and':   '000010',
    'or':    '000011', 'slt':   '000100', 'mul':   '000101',
    'lw':    '001000', 'sw':    '001001', 'addi':  '001010',
    'subi':  '001011', 'slti':  '001100', 'bneqz': '001101',
    'beqz':  '001110', 'hlt':   '111111', 'jump':  '001111'
}

# Simple mapping for register names to their 5-bit binary representation
# In your design, register numbers are used directly (e.g., R1, R2)
def reg_to_bin(reg_str):
    """Converts a register string like 'R5' to its 5-bit binary string '00101'."""
    try:
        # Assumes format R<number>
        reg_num = int(reg_str[1:])
        if 0 <= reg_num <= 31:
            return format(reg_num, '05b')
        else:
            raise ValueError
    except (ValueError, IndexError):
        print(f"ERROR: Invalid register name '{reg_str}'. Must be R0-R31.")
        exit(1)

def signed_imm_to_bin(imm_str, bits):
    """Converts a signed decimal immediate string to its two's complement binary string."""
    try:
        val = int(imm_str)
        if val < 0:
            val = (1 << bits) + val
        return format(val, f'0{bits}b')
    except ValueError:
        print(f"ERROR: Invalid immediate value '{imm_str}'.")
        exit(1)

def assemble(input_file='C:/Users/ASUS/visual code/Assembler/program.asm', output_file='C:/Users/ASUS/visual code/Assembler/program.hex'):
    """
    Reads an assembly file and writes the corresponding machine code to a hex file.
    
    Supported Formats:
    # R-Type: OPERATION rd, rs, rt
    #   e.g., add R3, R1, R2
    # I-Type: OPERATION rt, rs, immediate
    #   e.g., addi R2, R1, -100
    # Load/Store: OPERATION rt, offset(rs)
    #   e.g., lw R1, 200(R0)
    # Branch: OPERATION rs, offset
    #   e.g., beqz R5, -4
    # Jump: jump <instruction_address>
    #   e.g., jump 120    
    # Halt: HLT
    """
    print(f"Assembling {input_file} -> {output_file}...")
    
    lines_processed = 0
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        for line in f_in:
            line = line.strip().lower()
            if not line or line.startswith('#'):
                continue # Skip empty lines and comments

            # Tokenize by splitting on spaces, commas, and parentheses
            tokens = re.split(r'[ ,\t()]+', line)
            tokens = [t for t in tokens if t] # Remove empty strings

            op = tokens[0]
            machine_code_bin = ''

            if op not in OPCODES:
                print(f"ERROR: Unknown instruction '{op}'")
                continue

            opcode_bin = OPCODES[op]

            # R-Type: op rd, rs, rt
            if op in ['add', 'sub', 'and', 'or', 'slt', 'mul']:
                rd_bin = reg_to_bin(tokens[1])
                rs_bin = reg_to_bin(tokens[2])
                rt_bin = reg_to_bin(tokens[3])
                shamt_bin = '00000'
                funct_bin = '000000' # Not used in your design, but good practice
                machine_code_bin = opcode_bin + rs_bin + rt_bin + rd_bin + shamt_bin + funct_bin
            
            # I-Type: op rt, rs, imm
            elif op in ['addi', 'subi', 'slti']:
                rt_bin = reg_to_bin(tokens[1])
                rs_bin = reg_to_bin(tokens[2])
                imm_bin = signed_imm_to_bin(tokens[3], 16)
                machine_code_bin = opcode_bin + rs_bin + rt_bin + imm_bin

            # Load/Store Type: op rt, offset(rs)
            elif op in ['lw', 'sw']:
                rt_bin = reg_to_bin(tokens[1])
                imm_bin = signed_imm_to_bin(tokens[2], 16)
                rs_bin = reg_to_bin(tokens[3])
                machine_code_bin = opcode_bin + rs_bin + rt_bin + imm_bin

            # Branch Type: op rs, offset
            elif op in ['beqz', 'bneqz']:
                rs_bin = reg_to_bin(tokens[1])
                rt_bin = '00000' # rt is not used for this instruction in your design
                imm_bin = signed_imm_to_bin(tokens[2], 16)
                machine_code_bin = opcode_bin + rs_bin + rt_bin + imm_bin

            # Jump Type: jump <address>
            elif op =='jump':
                rs_bin = '00000'
                rt_bin = '00000'
                imm_bin = signed_imm_to_bin(tokens[1],16)
                machine_code_bin = opcode_bin + rs_bin + rt_bin + imm_bin

            # Halt Type: hlt
            elif op == 'hlt':
                machine_code_bin = opcode_bin + '0' * 26

            if machine_code_bin:
                machine_code_hex = format(int(machine_code_bin, 2), '08x')
                f_out.write(machine_code_hex + '\n')
                lines_processed += 1

    print(f"Assembly complete. {lines_processed} instructions written to {output_file}.")

if __name__ == '__main__':
    assemble()