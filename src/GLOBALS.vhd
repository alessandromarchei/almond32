library ieee;
use ieee.std_logic_1164.all;

package myTypes is

	type aluOp is (
		OP_NOP,
		OP_ADD,
		OP_ADC,
		OP_AND,
		OP_SRA,
		OP_OR,
		OP_SEQ,
		OP_SNE,
		OP_SLT,
		OP_SGT,
		OP_SLE,
		OP_SGE,
		OP_SLL,
		OP_SRL,
		OP_SUB,
		OP_XOR,
		OP_NOR,
		OP_XNOR,
		OP_NAND,
		OP_MUL
		);

end myTypes;

