# FPGA-TugOfWar
The Tug of War game contains 3 push buttons, 1 switch, 7 LEDs, and 1 FPGA.
It was my third year course ELEC3500 Lab Project.
Team Size: Two.

### About the Game
Two Players play against each other on a Xilinx FPGA development board.

## Game Flow:
### Game Start:
    1. After pushing reset, all the LEDs should come on for a second and then go off.

### Each Round:
    1. all the LEDs should come on for a second and then go off.
       This is the get ready signal.
    2. After a random time the middle LED comes on again.
       Then each player will try to push his button before the other player does.
    3. The position of the lit LED will move toward the fastest button pusher.
    
### End Game:
    The game is won when one player makes the position of the lit LED move off the end ofthe display.

## IDE & Hardware
     Developed on: Xilinx ISE
     Programming Language: Verilog
     Tested on: Xilinx Spartan 6
<img src="https://github.com/CCinCapital/FPGA-TugOfWar/blob/master/forREADME/Slide2-min.JPG"></img>

### System Diagram
<img src="https://github.com/CCinCapital/FPGA-TugOfWar/blob/master/forREADME/Slide3-min.JPG"></img>

