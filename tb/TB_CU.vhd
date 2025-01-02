library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.myTypes.all;

entity tb_dlx_cu is
end tb_dlx_cu;

architecture sim of tb_dlx_cu is
  
  -- COMPONENT DECLARATION
  component CU
    generic (
      MICROCODE_MEM_SIZE :     integer := 52;  -- Microcode Memory Size, MUST BE EQUAL TO THE ADDRESS OF LAST INSTRUCTION
      FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
      OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
      IR_SIZE            :     integer := 32;  -- Instruction Register Size    
      CW_SIZE            :     integer := 33);  -- Control Word Size
  
      Port (
        Clk                : in  std_logic;  -- Clock
        Rst                : in  std_logic;  -- Reset:Active-Low
        -- Instruction Register
        IR_IN              : in  std_logic_vector(IR_SIZE - 1 downto 0);

      -- IF Control Signal
        PC_EN       : out STD_LOGIC;
        NPC_EN      : out STD_LOGIC;
        IR_EN       : out STD_LOGIC;

      -- ID Control Signals
        PC2_EN      : out STD_LOGIC;    
        RF_EN       : out STD_LOGIC;
        RF_CALL     : out STD_LOGIC;
        RF_RET      : out STD_LOGIC;
        RF_RD1      : out STD_LOGIC;
        RF_RD2      : out STD_LOGIC;
        SIGND       : out STD_LOGIC;
        RF_FILL     : out STD_LOGIC;
        RF_SPILL    : out STD_LOGIC;
        RIMM_EN     : out STD_LOGIC;
        RA_EN       : out STD_LOGIC;
        RB_EN       : out STD_LOGIC;

      -- ALU Operation Code
        ALU_OPCODE         : out aluOp;

      -- EX Control Signals
        PC3_EN      : out STD_LOGIC;
        PSW_EN      : out STD_LOGIC;
        ALUA_SEL0   : out STD_LOGIC;
        ALUA_SEL1   : out STD_LOGIC;
        ALUB_SEL0   : out STD_LOGIC;
        ALUB_SEL1   : out STD_LOGIC;
        J_SEL0      : out STD_LOGIC;
        J_SEL1      : out STD_LOGIC;
        RWB1_EN     : out STD_LOGIC;

      -- MEM Control Signals
        RWB2_EN     : out STD_LOGIC;
        ALR_EN      : out STD_LOGIC;
        MEM_ADDR_SEL: out STD_LOGIC;
        MEM_DATA_SEL: out STD_LOGIC;
        B2_EN       : out STD_LOGIC;
        LMD_EN      : out STD_LOGIC;
        ALR2_EN     : out STD_LOGIC;
      
      -- WB Control signals
        WB_SEL      : out STD_LOGIC;
        RF_WR       : out STD_LOGIC
    );
  end component;
  
  constant CLOCK_PERIOD : time := 10 ns; -- Clock period
  signal clock: std_logic := '0';
  signal Rst, PC_EN, NPC_EN, PC2_EN, IR_EN, RF_EN, RF_CALL, RF_RET, RF_RD1, RF_RD2, SIGND, RF_FILL, RF_SPILL, RIMM_EN, RA_EN, RB_EN, PC3_EN, PSW_EN, ALUA_SEL0, ALUA_SEL1, ALUB_SEL0, ALUB_SEL1, J_SEL0, J_SEL1, RWB1_EN, RWB2_EN, ALR_EN, MEM_ADDR_SEL, MEM_DATA_SEL, B2_EN, LMD_EN, ALR2_EN, WB_SEL, RF_WR : std_logic;
    signal IR_IN : std_logic_vector(31 downto 0);
    signal ALU_OPCODE : aluOp;

begin
  -- clock
  clock <= not clock after 10 ns;
  
  -- CU instantiation
  DUT: CU
port map (
  clock,
  Rst         => Rst,
  IR_IN       => IR_IN,
  PC_EN       => PC_EN,
  NPC_EN      => NPC_EN,
  PC2_EN      => PC2_EN,
  IR_EN       => IR_EN,
  RF_EN       => RF_EN,
  RF_CALL     => RF_CALL,
  RF_RET      => RF_RET,
  RF_RD1      => RF_RD1,
  RF_RD2      => RF_RD2,
  SIGND        => SIGND,
  RF_FILL     => RF_FILL,
  RF_SPILL    => RF_SPILL,
  RIMM_EN     => RIMM_EN,
  RA_EN       => RA_EN,
  RB_EN       => RB_EN,
  ALU_OPCODE  => ALU_OPCODE,
  PC3_EN      => PC3_EN,
  PSW_EN      => PSW_EN,
  ALUA_SEL0   => ALUA_SEL0,
  ALUA_SEL1   => ALUA_SEL1,
  ALUB_SEL0   => ALUB_SEL0,
  ALUB_SEL1   => ALUB_SEL1,
  J_SEL0      => J_SEL0,
  J_SEL1      => J_SEL1,
  RWB1_EN     => RWB1_EN,
  RWB2_EN     => RWB2_EN,
  ALR_EN      => ALR_EN,
  MEM_ADDR_SEL=> MEM_ADDR_SEL,
  MEM_DATA_SEL=> MEM_DATA_SEL,
  B2_EN       => B2_EN,
  LMD_EN      => LMD_EN,
  ALR2_EN     => ALR2_EN,
  WB_SEL      => WB_SEL,
  RF_WR       => RF_WR
);

  -- Processo per caricare l'IR_IN con un'esempio di istruzione
  process
  begin

    Rst <= '0';
    wait for 20 ns;
    Rst <= '1';

    wait for 20 ns;

    -- Test R-Type

-- Esempio per SLL (Shift Left Logical) con FUNC 0x04, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000000100"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SRL (Shift Right Logical) con FUNC 0x06, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000000110"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SRA (Shift Right Arithmetic) FUNC 0x07, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000000111"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per ADD (Add) FUNC 0x20, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000100000"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SUB (Subtract) FUNC 0x22, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000100010"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per AND (Logical AND) FUNC 0x24, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000100100"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per OR (Logical OR) FUNC 0x25, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000100101"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per XOR (Logical XOR) FUNC 0x26, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000100110"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SEQ (Set if Equal) FUNC 0x28, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000101000"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SNE (Set if Not Equal) FUNC 0x29, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000101001"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SLT (Set if Less Than) FUNC 0x2a, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000101010"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SGT (Set if Greater Than) FUNC 0x2b, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000101011"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SLE (Set if Less Than or Equal) FUNC 0x2c, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000101100"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)
wait for 20 ns;

-- Esempio per SGE (Set if Greater Than or Equal) FUNC 0x2d, RS1 0x01, RS2 0x02, RD 0x03
IR_IN <= "00000000001000100000100000101101"; -- opcode(6) | RS1(5) | RS2(5) | RD(5) | FUNC(11)

-- Esempio per ADDI (Add Immediate)
IR_IN <= "0000100000100010" & "0000000000010000"; -- 0x08 | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

-- Esempio per SUBI (Subtract Immediate)
IR_IN <= "0000101000100010" & "0000000000010000"; -- 0x0A | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

-- Esempio per ANDI (AND Immediate)
IR_IN <= "0000110000100010" & "0000000000010000"; -- 0x0C | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

-- Esempio per ORI (OR Immediate)
IR_IN <= "0000110100100010" & "0000000000010000"; -- 0x0D | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

-- Esempio per XORI (XOR Immediate)
IR_IN <= "0000111000100010" & "0000000000010000"; -- 0x0E | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

-- Esempio per SLLI (Shift Left Logical Immediate)
IR_IN <= "0001010000100010" & "0000000000010000"; -- 0x14 | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

-- Esempio per SRLI (Shift Right Logical Immediate)
IR_IN <= "0001011000100010" & "0000000000010000"; -- 0x16 | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

-- Esempio per SRAI (Shift Right Arithmetic Immediate)
IR_IN <= "0001011100100010" & "0000000000010000"; -- 0x17 | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

-- Esempio per SNEI (Set if Not Equal Immediate)
IR_IN <= "0001100100100010" & "0000000000010000"; -- 0x19 | RS(5) | RT(5) | immediate(16)
wait for 20 ns;

wait for 20 ns;

    wait;
  end process;
  
  
  
 
  
end sim;
