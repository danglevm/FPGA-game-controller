# FPGA Game Controller

## Overview and Planning

A handheld game controller implented on the Altera MAX10 FPGA Development Board intended for playing more retro games. This project is inspired by the MiSTer FPGA: https://www.retrorgb.com/mister.html.

![image](https://github.com/danglevm/Game-Controller/assets/84720339/74f5bd01-fad1-48dc-a139-8e529caf2127)


## Files and Directories

### Directories
- `hdl` - contains all the Verilog source files (`*.v`) to be used for synthesis (testbenches are not placed here).
- `test` - all Verilog testbenches get placed in here
- `simulation` - Modelsim project and intermediate files
- `synthesis` - Quartus project and intermediate files - `.qpf`, `.sdc` and `.qsf` goes here.
- `ip` - files related to ip components - i.e. `pll`

### Files
- `BINARY_TO_7SEG_DISPLAY` - controls 7-segment display. Takes in 4-bit binary and output onto 7-bit display.
- `SPI_MASTER` - SPI Master interface for communication with accelerometer. 
- `VGA_CONTROLLER` - Controls VGA display on a 640 x 480 monitor.
- `UART_RX` - UART receiver
- `UART_RX` - UART transceiver


## Work-in-progress
The plan is to be able to launch and play the **Space Invaders** with the board acting as a game console. 2D movement is controlled by twisting and turning the FPGA; actions are taken by flipping switches and pressing buttons.

Accelerometer records input and transmits data to the FPGA through the SPI Master interface, then data from the FPGA is transmitted through the UART bus and then displayed on a monitor conforming to 640 x 480 VGA standard.

### Tasks
- Remake testbenches to be self-checking -- `UART_TX`, `UART_RX` and `VGA`.
- Planning and implementing the SDRAM-based FIFO.
- Create a SDRAM controller.
- Create a state machine for accelerometer and implement
- Testbenches for FIFO, SDRAM controller, accelerometer and finish SPI_MASTER_tb.

## Screenshots and Demo
