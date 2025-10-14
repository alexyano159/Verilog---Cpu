**#Multicycle Verilog CPU Project**

This repository contains the source code, testbenches, and documentation(png's of rtlview, waveforms and transcripts) for a custom multicycle 32-bit CPU.
The CPU suppors a variety of instruction types, including ALU operations, memory access and control flow (branch and jump).
I created this project as part of my learning journey in digital design, out of interest and curiosity in the field.

**#Features**

- **32-bit architecture**: All registers, data paths, and instructions are 32 bits wide.
- **Word-addressed memory**: Both instruction and data memory are word-addressed, with each word being 32 bits wide and 256 slots available.
- **Multicycle execution**: Each instruction executes over several clock cycles, closely modeling real-world CPU operation.
- **Custom instruction set**: Includes arithmetic, logical, load/store, and control flow instructions. Each instruction has its own unique opcode as defined in the instruction set.
- **Instruction and data memory modules**: Fully parameterized for easy modification.
- **Register file**: Supports asynchronous read and synchronous write, with reset and initialization logic.
- **Comprehensive testbenches**: Includes both memory and CPU top-level testing, with ModelSim simulation transcripts.
- **Clean design and documentation**: Each module is commented and easy to follow.
  
