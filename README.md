# Dual Port RAM (DPRAM) with ROM-Based Self-Test System

---

## Project Overview
This project implements a **basic on-chip memory subsystem** consisting of a **Dual Port RAM (DPRAM)** and a **Read-Only Memory (ROM)** along with supporting logic such as **address counters** and an **adder**.

The design demonstrates **independent read and write operations** using two address ports operating on **separate clock domains**, a concept commonly used in FIFO and buffer memory architectures.

---

## 🧠 Design Description
A **Dual Port RAM** provides two independent address ports.  
In this implementation:

- **Port A** is used for **write operations**
- **Port B** is used for **read operations**
- Read and write ports run on **different clock frequencies**

The **ROM** is pre-initialized with control data that:
- Provides an **offset value** to the adder
- Controls the **Write Enable (WEA)** signal of the DPRAM

This configuration creates a **self-testing loop** that verifies the correctness of memory access and data integrity.

---

## ⚙️ Functional Flow
1. ROM outputs offset and write enable signals
2. Up counter generates write address
3. Down counter generates read address
4. Adder combines input data with ROM offset
5. Modified data is written into DPRAM
6. Data is read back via second port to validate operation

---

## 🧩 Block Diagram
<p align="center">
  <img src="Images/Block diagram.jpg" alt=" Pin diagram" width="800">
</p>

---

## 🗂️ Project File Structure
```
├── top.v # Top-level module
├── dpram.v # Dual Port RAM module
├── rom.v # ROM module
├── rom_data.mem # ROM initialization file
├── up_counter.v # Write address counter
├── down_counter.v # Read address counter
├── adder.v # Adder logic
├── tb_top_memory_system.v # Testbench
```

---

## Simulation Results

<p align="center">
  <img src="Images/Simulation report.jpeg" alt=" Pin diagram" width="800">
</p>

---

##  Synthesis
<p align="center">
  <img src="Images/Netlist block diagram.jpeg" alt=" Pin diagram" width="800">
</p>

---

## 📊 Resource Utilization
<p align="center">
  <img src="Images/1" alt=" Pin diagram" width="800">
</p>
<p align="center">
  <img src="Images/2" alt=" Pin diagram" width="800">
</p>
<p align="center">
  <img src="Images/3" alt=" Pin diagram" width="800">
</p>
<p align="center">
  <img src="Images/4" alt=" Pin diagram" width="800">
</p>
<p align="center">
  <img src="Images/5" alt=" Pin diagram" width="800">
</p>
<p align="center">
  <img src="Images/6" alt=" Pin diagram" width="800">
</p>

---

## 🚀 Key Features
- True dual-port RAM architecture
- Independent read and write clocks
- ROM-based self-testing mechanism
- Modular and reusable Verilog design
- Fully synthesizable for FPGA implementation

---

## 📚 Applications
- FIFO memory systems
- On-chip buffering
- FPGA memory interface verification
- Digital design and VLSI academic projects

---

## ✅ Conclusion
This project demonstrates a **robust dual-port memory system** with ROM-controlled self-test logic. It provides practical exposure to **clock-domain separation, memory interfacing, and FPGA-based on-chip memory design**.

---
