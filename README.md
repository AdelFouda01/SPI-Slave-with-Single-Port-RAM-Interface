# SPI-Slave-with-Single-Port-RAM-Interface
Full RTL-to-FPGA flow of an SPI Slave with a Single-Port RAM. Verified via QuestaSim and achieved a 99.1% QuestaLint score. Synthesized on Vivado, conducting a deep architectural analysis on FSM encodings (One-hot, Gray, Sequential) which proved Gray encoding yielded the best timing margin (WNS 4.503 ns).
