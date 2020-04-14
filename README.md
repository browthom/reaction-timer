# reaction-timer
VHDL model for implementation on a Digilent Basys 3 Artix-7 development board. The 7-segment display will show 0000 for three seconds before counting up by 1 every 1ms. If the user presses BTNC, the counter will pause and the display will remain at the current count value. The counter will pause if it reaches 9999. If BTNU is pressed, the counter is reset and the entire process starts over.

_The browthom/vhdl-user-component-dir repository must be imported into the Vivado project as a directory. This is done so that the top_level.vhd file can properly instantiate all components listed in its vhdl model._
