NOTE FOR TESTBENCHING:

The /codes repository contains custom assembly code files that should be used instead of the standard assembly code files elaborated by the compiler. 


The standard compiler encodes instructions differently, leading, for instance, to opcode discrepancies for R-type instructions and operand miscoding. Our custom files are built correcting this issue.

We recommend to test the system with linear_plot_compiled.txt, as this code is complex and highlight every feature of the system: from forwarding to branch prediction and hazard management, from adder to multiplier and comparator.


Download the assembly files from /codes repository.


