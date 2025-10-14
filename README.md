# Multicycle Verilog CPU Project

This repository contains the source code, testbenches, and documentation(png's of rtlview, waveforms and transcripts) for a custom multicycle 32-bit CPU.
The CPU suppors a variety of instruction types, including ALU operations, memory access and control flow (branch and jump).
I created this project as part of my learning journey in digital design, out of interest and curiosity in the field.

## Features

- **32-bit architecture**: All registers, data paths, and instructions are 32 bits wide.
- **Word-addressed memory**: Both instruction and data memory are word-addressed, with each word being 32 bits wide and 256 slots available.
- **Multicycle execution**: Each instruction executes over several clock cycles, closely modeling real-world CPU operation.
- **Custom instruction set**: Includes arithmetic, logical, load/store, and control flow instructions. Each instruction has its own unique opcode as defined in the instruction set.
- **Instruction and data memory modules**: Fully parameterized for easy modification.
- **Register file**: Supports asynchronous read and synchronous write, with reset and initialization logic.
- **Comprehensive testbenches**: Includes both memory and CPU top-level testing, with ModelSim simulation transcripts.
- **Clean design and documentation**: Each module is commented and easy to follow.

## How to Run

1. **Clone the repository:**
   ```sh
   git clone https://github.com/alexyano159/Verilog_Multicycle_CPU.git
   ```
2. **Open in ModelSim (or another simulator):**
   - Compile all Verilog modules and testbenches.
   - Run the simulation for the desired time (for demo purposes, the transcript shows the first 500 seconds).
   - You can extend the simulation time to test more instructions if you want to.

## Example Output

The following is a sample of the simulation transcript (ModelSim), showing the CPU fetching and executing instructions:

```
# Time: 27 | PC: 00000000 | IR: 00000000 | ALU: 00000000 | MDR: 00000000 | Reg1: 00000000 | Reg2: 00000000 | RegWrite: 0 | MemWrite: 0 | AluCtrl: 00 | Jump: 0 | Branch: 0
# Time=27 | PC=00000000 | IR=00000000 | Reg1=00000000 | Reg2=00000000 | ALU=00000000 | MAR=00 | MDR=00000000 | DataAddr=00 | WriteData=00000000 | WriteEn=0
# Time: 45 | PC: 00000000 | IR: 00443000 | ALU: 12345679 | MDR: 00000000 | Reg1: 12345678 | Reg2: 00000001 | RegWrite: 0 | MemWrite: 0 | AluCtrl: 00 | Jump: 0 | Branch: 0
# Time=45 | PC=00000000 | IR=00443000 | Reg1=12345678 | Reg2=00000001 | ALU=12345679 | MAR=00 | MDR=00000000 | DataAddr=00 | WriteData=00000001 | WriteEn=0
# Time: 63 | PC: 00000004 | IR: 00443000 | ALU: 12345679 | MDR: 00000000 | Reg1: 12345678 | Reg2: 00000001 | RegWrite: 1 | MemWrite: 0 | AluCtrl: 00 | Jump: 0 | Branch: 0
# Time=63 | PC=00000004 | IR=00443000 | Reg1=12345678 | Reg2=00000001 | ALU=12345679 | MAR=00 | MDR=00000000 | DataAddr=00 | WriteData=00000001 | WriteEn=0
...
```

*Only the first part of the simulation is shown. You can run longer tests as needed.*

## Design Files

- `CPU_Top.v` – Main CPU module
- `Instruction_Memory.v` – Instruction ROM
- `Data_Memory.v` – Data RAM
- `Register_File.v` – Register file
- `Control_Unit.v` – Central control logic
- `alu_module.v` – Arithmetic Logic Unit (ALU) implementation
- `Memory_Data_Register.v` – Memory Data Register (MDR)
- `Memory_Address_Register.v` – Memory Address Register (MAR)
- `Program_Counter.v` – Program Counter (PC)
- `Instruction_Register.v` – Instruction Register (IR)

## Testbenches

- `CPU_Top_tb.v` – Top-level CPU testbench
- `Instruction_Memory_tb.v` – Instruction memory testbench
- `Data_Memory_tb.v` – Data memory testbench
- `Register_File_tb.v` – Register file testbench
- `Control_Unit_tb.v` – Control unit testbench
- `alu_tb.v` – ALU testbench
- `Memory_Data_Register_tb.v` – Memory Data Register testbench
- `Memory_Address_Register_tb.v` – Memory Address Register testbench
- `Program_Counter_tb.v` – Program Counter testbench
- `Instruction_Register_tb.v` – Instruction Register testbench

## Constraints Files

- `CPU_Top.sdc` – Synthesis constraints for FPGA/ASIC implementation; defines the clock for the top-level CPU module

## Documentation Files
- `instruction_set.md` – Full list of supported instructions and opcodes
- `RTL_Views/` – Folder containing RTL schematic views of CPU modules
- `Waveform+transcripts/` – Folder containing simulation waveforms and ModelSim 

## About the Project

This project was developed and documented by **alexyano159**.  
During development, I used **GitHub Copilot** as an AI assistant for code structure, debugging, and documentation, which helped accelerate my learning and improve code quality.

**Questions or suggestions?**  
Open an issue or contact me at [alexyano159@gmail.com]!
