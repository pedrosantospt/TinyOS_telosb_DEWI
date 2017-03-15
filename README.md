# TinyOS_telob_dewi
DEWI project implementation

# Build Instructions
cd src/
make telosb

#Check nodes connected
motelist

# Upload Code Instructions
make telosb reinstall,{TOS_NODE_ID} bsl,{DEVICE}
Example:
make telosb reinstall,2 bsl,/dev/ttyUSB0

