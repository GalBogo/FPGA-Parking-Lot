# FPGA Parking Lot Controller 

A simple Finite State Machine (FSM) implementation for a smart parking lot system on the **Lattice iCE40** FPGA.

##  Overview
This module tracks the number of cars in a lot and controls entry/exit gates. It demonstrates fundamental digital logic concepts:
* **Edge Detection:** Detecting signals from entry/exit sensors.
* **FSM Design:** Handling states (IDLE, OPEN_GATE, FULL).
* **Counter Logic:** Tracking capacity (Max: 3 cars).

##  Logic Flow
1. **IDLE:** Waits for `car_enter` or `car_exit` signals.
2. **OPEN_GATE:** triggers the gate to open (Green LED).
3. **FULL:** Blocks entry when capacity is reached (Red LED).

##  Hardware Mapping
* **Inputs:** Toggle switches (simulating sensors).
* **Outputs:** LEDs (Red = Full, Green = Gate Open).
