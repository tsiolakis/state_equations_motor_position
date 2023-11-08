# State Equations - Motor Position Control
Control the position of a motor using state equations with the **[MATLAB support package for Arduino Hardware](https://www.mathworks.com/matlabcentral/fileexchange/47522-matlab-support-package-for-arduino-hardware)**

The experimental setup consists of two main sections. The first section includes all the electronic arrangements for closing the feedback loop, primarily implemented using operational amplifiers (op-amps). The second section contains a motor with its measurement systems. The measurement systems comprise a tachogenerator for measuring the speed of the axis and a potentiometer for measuring the position of the axis. The potentiometer's wiper is connected to the motor's axis. Since the motor rotates continuously, the potentiometer's wiper does not have a mechanical stop. This means that after completing one full rotation from one end (point A) to the other end (point C), it moves back to the initial position at point A.

The control environment for the motor consists of a small Arduino Uno microcontroller platform, a power supply circuit for the motor (which also acts as a receiver of the motor's states, such as position and velocity), and a transmitter of control signals to the motor. Additionally, there is an interface between the Arduino Uno and the aforementioned circuit. It's worth noting that the interface is powered by the motor's power supply circuit as well.
![system](https://github.com/tsiolakis/state_equations_motor_position/assets/62109828/7bdabe9b-f193-43f7-b877-5f2da1be5bad)

#### Repository Structure
- matlab_code - A folder containing the MATLAB implementations of the controllers and the observer.
- matlab_helpers - A folder with auxiliary MATLAB scripts:
  - STOP - Stops the motor.
  - POS - Prints the position of the motor to the MATLAB console.
  - PLOT - Used for plotting.
- images - Experimental results visualized in images, with most of them included in the report.
- results - A folder containing experimental results collected during lab visits in .mat files.
- Motor Position Control - State Equations.pdf detailed report discussing system model, deriving state equations, impmelementing controllers and measuring their accuracy. 
