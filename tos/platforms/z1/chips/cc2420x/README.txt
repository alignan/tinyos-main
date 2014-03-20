CC2420X is an alternative radio stack for the TI CC2420 radio, using the
rfxlink library (lib/rfxlink). The stack is IEEE802.15.4 compliant. All
rfxlink features are supported. See lib/rfxlink/README.txt for details.

The stack can be used with microsecond-precision timestamping, as well as
with 32khz timestamping. 

To use this stack with microsecond precision timestamping configuration,
compile the application with the cc2420x extra:

make z1 cc2420x

To use this stack with 32khz precision timestamping configuration, add
the following lines to the Makefile:

make z1 cc2420x_32khz

