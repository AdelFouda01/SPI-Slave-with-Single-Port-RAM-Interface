# SPI Slave with Single-Port RAM Interface: Full RTL-to-Implementation Flow

## 📌 Project Overview
A complete hardware design, verification, and implementation cycle of an **SPI Slave integrated with a Single-Port RAM (256x8)**. This was a collaborative engineering project designed to apply the full RTL-to-FPGA flow, focusing heavily on design quality, linting, and architectural trade-offs.

* **Collaborators:** Adel El Sayed Ibrahim & Omar Gamal Mohamed

## 🛠️ EDA Tools & Methodologies
* **RTL Design & Testbench:** Verilog HDL
* **Functional Verification:** QuestaSim
* **Formal Verification (Linting):** QuestaLint
* **Synthesis & Implementation:** AMD Xilinx Vivado (Target: xc7a35ticpg236-1L)

## 🏆 Key Technical Achievements
### 1. Exceptional Code Quality (Linting)
* Achieved a **99.1% Quality Score** on QuestaLint prior to synthesis.
* Reached 100% readiness in Nomenclature Style, Simulation, and Implementation, with zero functional lint errors.

### 2. Functional Verification
* Verified 4 sequential transactions (Write Address, Write Data, Read Address, Read Data).
* Confirmed stable cycle-accurate deserialization and single-cycle valid assertions.

### 3. FSM Encoding Deep-Dive Analysis
We did not stop at functional correctness; we conducted a comparative architectural analysis of the SPI Slave FSM state register (`cs_reg`) using three different encodings post-implementation:
* **One-hot:** WNS = 4.215 ns | LUTs = 1240
* **Sequential:** WNS = 4.241 ns | LUTs = 1234
* **Gray:** WNS = 4.503 ns | LUTs = 1237

**💡 Engineering Conclusion:** 
For our routed design on the targeted fabric, **Gray encoding** delivered the best post-implementation timing margin (WNS 4.503 ns). Despite One-hot being commonly favored for speed, it yielded the tightest timing margin and highest resource utilization in this specific architecture.
