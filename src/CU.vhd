library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

entity CU is
  generic (
    MICROCODE_MEM_SIZE :     integer := 62;  -- Microcode Memory Size, MUST BE EQUAL TO THE ADDRESS OF LAST INSTRUCTION
    FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
    OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
    IR_SIZE            :     integer := 32;  -- Instruction Register Size    
    CW_SIZE            :     integer := 26);  -- Control Word Size

    Port (
        Clk                : in  std_logic;  -- Clock
        Rst                : in  std_logic;  -- Reset:Active-Low
        STALL              : in std_logic_vector(1 downto 0); -- Signal the CU to stall: 00 nothing, 01 only cw2 and cw3, 01 all
        -- Instruction Register
        IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0);
        BMP                : in  std_logic;  -- Branch MisPrediction bit
       
      -- ID Control Signals
        ID_EN       : out STD_LOGIC;
        RF_RD       : out STD_LOGIC;
        SIGND       : out STD_LOGIC;
        IMM_SEL     : out STD_LOGIC;
        BPR_EN      : out STD_LOGIC; --branch prediction register enable used to turn on the BHT
        UCB_EN      : out STD_LOGIC;

      -- ALU Operation Code
        ALU_OPCODE  : out aluOp;

      -- EX Control Signals
        EX_EN       : out STD_LOGIC;
        ALUA_SEL    : out STD_LOGIC;
        ALUB_SEL    : out STD_LOGIC;

      -- MEM Control Signals
        MEM_EN      : out STD_LOGIC;
        MEM_DATA_SEL: out STD_LOGIC;
        MEM_RD      : out STD_LOGIC;
        MEM_WR      : out STD_LOGIC;
        CS          : out STD_LOGIC;    --CHIP SELECT for the memory
        MEM_BLC0    : out STD_LOGIC;    --BYTE LANE CONTROLS : USED TO CONFIGURE THE TYPE OF STORE OF THE MEMORY : SB, SH, SW
        MEM_BLC1    : out STD_LOGIC;
        LD_SEL0     : out STD_LOGIC;    --USED TO SELECT THE PROPER CONFIGURATION AT THE MEMORY OUTPUT (DEPENDING ON TYPE OF LOAD)
        LD_SEL1     : out STD_LOGIC;
        LD_SEL2     : out STD_LOGIC;
        ALR2_SEL    : out STD_LOGIC;
        CWB_SEL0    : out STD_LOGIC;    --CONDITION WRITE BACK SELECTOR
        CWB_SEL1    : out STD_LOGIC;    --CONDITION WRITE BACK SELECTOR
        
      -- WB Control signals
        WB_SEL      : out STD_LOGIC;
        RF_WR       : out STD_LOGIC;
        RF_MUX_SEL0: out STD_LOGIC;
        RF_MUX_SEL1: out STD_LOGIC
    );
end CU;


architecture dlx_cu_hw of CU is

  type mem_array is array (integer range 0 to MICROCODE_MEM_SIZE - 1) of std_logic_vector(CW_SIZE - 1 downto 0);
  signal cw_mem : mem_array := (
    "11000010010000000000000100",          -- R-TYPE [0x00]:
    "11000010010000000000000100",          -- F-TYPE [0x01]:
    "10010100000000000000000000",          -- J [0x02]:
    "11010110010000000001000101",          -- JAL [0x03]:
    "11001010010000000000000000",          -- BEQZ [0x04]: 
    "11001010010000000000000000",          -- BNEZ [0x05]: 
    "00000000000000000000000000",          -- BFPT [0x06]: 
    "00000000000000000000000000",          -- BFPF [0x07]: 
    "11100010110000000000000110",          -- ADDI [0x08]: 
    "11000010110000000000000110",          -- ADDUI [0x09]: 
    "11100010110000000000000110",          -- SUBI [0x0A]: 
    "11000010110000000000000110",          -- SUBUI [0x0B]: 
    "11000010110000000000000110",          -- ANDI [0x0C]: 
    "11000010110000000000000110",          -- ORI [0x0D]: 
    "11000010110000000000000110",          -- XORI [0x0E]: 
    "11100010110000000000100110",          -- LHI [0x0F]: 
    "00000000000000000000000000",          -- RFE [0x10]: 
    "00000000000000000000000000",          -- TRAP [0x11]: 
    "00000000000000000000000000",          -- JR [0x12]:    
    "00000000000000000000000000",          -- JALR [0x13]: 
    "11000010110000000000000110",          -- SLLI [0x14]: 
    "10000010010000000000000000",          -- NOP [0x15]: 
    "11000010110000000000000110",          -- SRLI [0x16]: 
    "11000010110000000000000110",          -- SRAI [0x17]: 
    "11100010110000000000010110",          -- SEQI [0x18]: 
    "11100010110000000000010110",          -- SNEI [0x19]: 
    "11100010110000000000010110",          -- SLTI [0x1A]: 
    "11100010110000000000010110",          -- SGTI [0x1B]: 
    "11100010110000000000010110",          -- SLEI [0x1C]: 
    "11100010110000000000010110",          -- SGEI [0x1D]: 
    "00000000000000000000000000",          -- blank [0x1E]: 
    "00000000000000000000000000",          -- blank [0x1F]: 
    "11100010110101001000001110",          -- LB [0x20]: 
    "11100010110101001100001110",          -- LH [0x21]: 
    "00000000000000000000000000",          -- BLANK         
    "11100010110101000000001110",          -- LW [0x23]:    
    "11100010110101000100001110",          -- LBU [0x24]: 
    "11100010110101000010001110",          -- LHU [0x25]: 
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "11100010111011100000000000",          -- SB [0x28]: 
    "11100010111011010000000000",          -- SH [0x29]: 
    "00000000000000000000000000",          -- BLANK
    "11100010111011000000000000",          -- SW [0x2B]:
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "00000000000000000000000000",          -- BLANK
    "11000010110000000000010110",          -- SLTUI [0x3A]: 
    "11000010110000000000010110",          -- SGTUI [0x3B]: 
    "11000010110000000000010110",          -- SLEUI [0x3C]: 
    "11000010110000000000010110"           -- SGEUI [0x3D]: 
    );
                                                           
  signal IR_opcode : std_logic_vector(OP_CODE_SIZE -1 downto 0) := (others => '0');  -- OpCode part of IR, to store OPCODE FIELD OF EACH IR
  signal IR_func : std_logic_vector(FUNC_SIZE - 1 downto 0) := (others => '0');   -- Func part of IR when Rtype, to store FUNC FIELD OF EACH IR
  signal cw   : std_logic_vector(CW_SIZE - 1 downto 0) := (others => '0'); -- full control word read from cw_mem

  -- control word is shifted to the correct stage, PIPELINE IMPLEMENTATION thanks to the cwi registers
  --signal cw1 : std_logic_vector(CW_SIZE -1 downto 0) := (others => '0'); -- first stage (IF_EN)
  signal cw2 : std_logic_vector(CW_SIZE -1 downto 0) := (others => '0'); -- second stage  (ID_EN,RF_RD,SIGND,IMM_SEL, BPR_EN, UCB_EN)
  signal cw3 : std_logic_vector(CW_SIZE -1 -6 downto 0) := (others => '0'); -- third stage (EX_EN, ALUA_SEL, ALUB_SEL)
  signal cw4 : std_logic_vector(CW_SIZE -1 -6 -3 downto 0) := (others => '0'); -- fourth stage  (MEM_EN, MEM_DATA_SEL, MEM_RD, MEM_WR, CS, MEM_BLC0, MEM_BLC1, LD_SEL0, LD_SEL1, LD_SEL2, ALR2_SEL, CWB_SEL0, CWB_SEL1)
  signal cw5 : std_logic_vector(CW_SIZE -1 -6 -3 -13 downto 0) := (others => '0'); -- fifth stage (WB_SEL, RF_WR, RF_MUX_SEL0, RF_MUX_SEL1)

  signal aluOpcode_i: aluOp := OP_NOP; -- ALUOP defined in package

  --REGISTERS TO IMPLEMENT THE PIPELINE OF THE ALU
  signal aluOpcode1: aluOp := OP_NOP;
  signal aluOpcode2: aluOp := OP_NOP;
 
begin

  IR_opcode(5 downto 0) <= IR_IN(31 downto 26);   -- LOADING OPCODE SECTION FROM IR 
  IR_func(10 downto 0)  <= IR_IN(FUNC_SIZE - 1 downto 0);   -- LOADING FUNC SECTION FROM IR 
  cw <= cw_mem(conv_integer(IR_opcode));    --ACCESSING MICROCODE MEMORY TO GET THE FULL CONTROL WORD


-- Assignments for ID Control Signals
ID_EN       <= cw2(CW_SIZE - 1);
RF_RD       <= cw2(CW_SIZE - 2);
SIGND       <= cw2(CW_SIZE - 3);
IMM_SEL     <= cw2(CW_SIZE - 4);
BPR_EN      <= cw2(CW_SIZE - 5);
UCB_EN      <= cw2(CW_SIZE - 6);

-- Assignments for EX Control Signals
EX_EN       <= cw3(CW_SIZE - 7);
ALUA_SEL    <= cw3(CW_SIZE - 8);
ALUB_SEL    <= cw3(CW_SIZE - 9);

-- for MEM Control Signals  
MEM_EN      <= cw4(CW_SIZE - 10);
MEM_DATA_SEL<= cw4(CW_SIZE - 11);
MEM_RD      <= cw4(CW_SIZE - 12);
MEM_WR      <= cw4(CW_SIZE - 13);
CS          <= cw4(CW_SIZE - 14);
MEM_BLC0    <= cw4(CW_SIZE - 15);
MEM_BLC1    <= cw4(CW_SIZE - 16);
LD_SEL0     <= cw4(CW_SIZE - 17);
LD_SEL1     <= cw4(CW_SIZE - 18);
LD_SEL2     <= cw4(CW_SIZE - 19);
ALR2_SEL    <= cw4(CW_SIZE - 20);
CWB_SEL0    <= cw4(CW_SIZE - 21);
CWB_SEL1    <= cw4(CW_SIZE - 22);

-- Assignments for WB Control signals
WB_SEL      <= cw5(CW_SIZE - 23);
RF_WR       <= cw5(CW_SIZE - 24);
RF_MUX_SEL0 <= cw5(CW_SIZE - 25);
RF_MUX_SEL1 <= cw5(CW_SIZE - 26);

  -- process to pipeline control words
  CW_PIPE: process (Clk, Rst, STALL, BMP)
  begin  -- process Clk
    if Rst = '1' then                   -- asynchronous reset (active high)
      cw2 <= (others => '0');
      cw3 <= (others => '0');
      cw4 <= (others => '0');
      cw5 <= (others => '0');
      aluOpcode1 <= OP_NOP;
      aluOpcode2 <= OP_NOP;
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      if BMP = '1' then
        -- Reset due to branch misprediction
        cw2 <= cw(CW_SIZE -1 downto 0);
        cw4 <= cw3(CW_SIZE -1 -6 -3 downto 0);
        cw5 <= cw4(CW_SIZE -1 -6 -3 -13 downto 0);
        cw3 <= (others => '0');       
        aluOpcode2 <= OP_NOP;
        aluOpcode1 <= aluOpcode_i;

      elsif STALL = "01" then
        -- Raw hazard management
        cw4 <= cw3(CW_SIZE -1 -6 -3 downto 0);
        cw5 <= cw4(CW_SIZE -1 -6 -3 -13 downto 0);
      elsif STALL = "00" then
        --SHIFTING THE VARIOUS CONTROL WORDS TO THE NEXT STAGE
        cw2 <= cw(CW_SIZE -1 downto 0);
        cw3 <= cw2(CW_SIZE -1 -6 downto 0);
        cw4 <= cw3(CW_SIZE -1 -6 -3 downto 0);
        cw5 <= cw4(CW_SIZE -1 -6 -3 -13 downto 0);
        aluOpcode1 <= aluOpcode_i;
        aluOpcode2 <= aluOpcode1;
      end if;
    end if;
end process;

  ALU_OPCODE <= aluOpcode2;     --ASSIGNING the delayed Aluopcode to the external DATAPATH

  -- purpose: Generation of ALU OpCode
  -- type   : combinational
  -- inputs : IR_i
  -- outputs: aluOpcode
  -- ALUOPCODES == SIGNALS TO SEND TO THE ALU IN ORDER TO PERFORM ALL THE FUNCTIONS SUCH AS AND,OR,ADD,SUB etc..
  -- OPCODE = 0 ==> R-TYPE INSTRUCTION, so FUNC IS USED
  -- OPCODE != 0 ==> I-TYPE or J-TYPE INSTRUCTION, SO FUNC IS NOT USED
   ALU_OP_CODE_P : process (IR_opcode, IR_func)
   begin  -- process ALU_OP_CODE_P
	case conv_integer(unsigned(IR_opcode)) is

	        -- case of R type requires decoding FUNC
		when 0 =>
			case conv_integer(unsigned(IR_func)) is

				when 4 => aluOpcode_i <= OP_SLL; -- sll according to instruction set coding
				when 6 => aluOpcode_i <= OP_SRL;
        when 7 => aluOpcode_i <= OP_SRA;
        when 32 => aluOpcode_i <= OP_ADD; 
        when 34 => aluOpcode_i <= OP_SUB; 
        when 35 => aluOpcode_i <= OP_ADC; 
        when 36 => aluOpcode_i <= OP_AND; 
        when 37 => aluOpcode_i <= OP_OR; 
        when 38 => aluOpcode_i <= OP_XOR; 
        when 40 => aluOpcode_i <= OP_SEQ; 
        when 41 => aluOpcode_i <= OP_SNE; 
        when 42 => aluOpcode_i <= OP_SLT;
        when 43 => aluOpcode_i <= OP_SGT;
        when 44 => aluOpcode_i <= OP_SLE;
        when 45 => aluOpcode_i <= OP_SGE;
        when 58 => aluOpcode_i <= OP_SLT;   -- sltu
        when 59 => aluOpcode_i <= OP_SGT;   -- sgtu
        when 60 => aluOpcode_i <= OP_SLE;   -- sleu
        when 61 => aluOpcode_i <= OP_SGE;   -- sgeu
    
				when others => aluOpcode_i <= OP_NOP;
			end case;
    
    --F-TYPE INSTRUCTIONS with OPCODE = 0x01
    when 1 => case conv_integer(unsigned(IR_func)) is
      when 14 => aluOpcode_i <= OP_MUL;
  
      when others => aluOpcode_i <= OP_NOP;
    end case;

    --CASES IN WHICH FUNC IS NOT USED, but only OPCODE IS USED, BUT THE ALU RECEIVES ONLY THE SAME SIGNALS
		when 8 => aluOpcode_i <= OP_ADD;    -- addi
    when 9 => aluOpcode_i <= OP_ADD;    -- addui
    when 10 => aluOpcode_i <= OP_SUB;   -- subi
    when 11 => aluOpcode_i <= OP_SUB;   -- subi
		when 12 => aluOpcode_i <= OP_AND;   -- andi
		when 13 => aluOpcode_i <= OP_OR;    -- ori
    when 14 => aluOpcode_i <= OP_XOR;   -- xori
    when 15 => aluOpcode_i <= OP_ADD;   -- lhi  (imm16 + 0)
		when 20 => aluOpcode_i <= OP_SLL;   -- slli
    when 22 => aluOpcode_i <= OP_SRL;   -- srli
    when 23 => aluOpcode_i <= OP_SRA;   -- srai
    when 24 => aluOpcode_i <= OP_SEQ;   -- seqi
		when 25 => aluOpcode_i <= OP_SNE;   -- snei
    when 26 => aluOpcode_i <= OP_SLT;   -- slti
    when 27 => aluOpcode_i <= OP_SGT;   -- sgti
    when 28 => aluOpcode_i <= OP_SLE;   -- slei
    when 29 => aluOpcode_i <= OP_SGE;   -- sgei
    when 32 => aluOpcode_i <= OP_ADD;   -- lb
    when 33 => aluOpcode_i <= OP_ADD;   -- lh
    when 35 => aluOpcode_i <= OP_ADD;   -- lw
    when 36 => aluOpcode_i <= OP_ADD;   -- lbu
    when 37 => aluOpcode_i <= OP_ADD;   -- lhu
    when 40 => aluOpcode_i <= OP_ADD;   -- sb
    when 41 => aluOpcode_i <= OP_ADD;   -- sh
    when 43 => aluOpcode_i <= OP_ADD;   -- sw
    when 58 => aluOpcode_i <= OP_SLT;   -- sltui
    when 59 => aluOpcode_i <= OP_SGT;   -- sgtui
    when 60 => aluOpcode_i <= OP_SLE;   -- sleui
    when 61 => aluOpcode_i <= OP_SGE;   -- sgeui

		when others => aluOpcode_i <= OP_NOP;
	 end case;
	end process ALU_OP_CODE_P;

end dlx_cu_hw;
