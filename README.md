
# Almond-32 Microprocessor

**Almond-32** is a RISC-V-based microprocessor inspired by the DLX architecture. It implements advanced pipelining, hazard management, and low-power optimizations to achieve efficient performance.

## **Table of Contents**
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Architecture](#architecture)
4. [Instruction Set](#instruction-set)
5. [Pipeline Stages](#pipeline-stages)
6. [Components](#components)
7. [Synthesis and Results](#synthesis-and-results)
8. [How to Run](#how-to-run)
9. [Contributors](#contributors)

---

## **Project Overview**
Almond-32 is a custom 32-bit microprocessor developed as part of a Master's project in Electronics Engineering at Politecnico di Torino. The design is tailored for applications requiring low power consumption and high efficiency.

---

## **Features**
- **RISC Architecture**: Based on the DLX model, supporting 32 registers.
- **Pipeline**: Five-stage pipeline for parallel instruction execution.
- **Hazard Management**: Advanced detection and resolution mechanisms for data and structural hazards.
- **Branch Prediction**: Includes a 2-bit Branch History Table (BHT) for optimized branching.
- **Efficient Arithmetic Units**: ALU supports addition, subtraction, logic, shifting, and multiplication with pipelined Booth's algorithm.
- **Custom Memory Management**: Big-endian, byte-addressable DRAM.

---

## **Architecture**
### **Block Diagram**
Refer to `architecture_diagram.png` for a visual representation of the system.

### **Core Units:**
1. **Control Unit (CU)**: Hardwired for instruction decoding and pipeline management.
2. **Arithmetic Logic Unit (ALU)**: Implements adders, shifters, comparators, and multipliers.
3. **Memory Units**:
   - DRAM (Data Memory)
   - IRAM (Instruction Memory)
4. **Hazard Management**:
   - Hazard Detection Unit (HDU)
   - Forwarding Unit (FWDU)

---

## **Instruction Set**
The processor supports three types of instructions:
- **R-Type**: Arithmetic and logical operations.
- **I-Type**: Memory access and immediate operations.
- **J-Type**: Jumps and branches.

Detailed instruction formats and examples can be found in the `docs/instruction_set.md`.

---

## **Pipeline Stages**
1. **Instruction Fetch (IF)**
2. **Instruction Decode (ID)**
3. **Execution (EXE)**
4. **Memory Access (MEM)**
5. **Write Back (WB)**

Each stage is designed with hazard management to maintain data integrity, thanks to the **Hazard Detection Unit (HDU)**.

---

## **Components**
- **ALU**: Pentium-4 inspired adder, shifter, multiplier (pipelined), and comparator.
- **Branch Prediction**: Optimized with a 4-state BHT for conditional branching.
- **Forwarding Unit**: Resolves data hazards dynamically.
- **Control Unit**: Provides synchronization and generates control signals for each stage.

---

## **Synthesis and Results**
- Synthesized using industry-standard tools.
- Optimized for area and power consumption.
- Achieves clock speeds suitable for embedded applications.

---

## **How to Run**
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/almond32.git
   ```
2. Navigate to the project directory and follow the simulation instructions in `docs/simulation.md`.

---

## **Contributors**
- [Alessandro Marchei](https://github.com/alessandromarchei)
- Silvia Capozzoli
- [Tommaso Terzano](https://github.com/TommiTerza)

For more details, refer to the full project documentation in the `docs/report.pdf' file, where the complete report of the architecture is presented.
