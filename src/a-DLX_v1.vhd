library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;

entity DLX is
  generic (
    IR_SIZE      : integer := 32;       -- Instruction Register Size
    PC_SIZE      : integer := 32       -- Program Counter Size
    );       -- ALU_OPC_SIZE if explicit ALU Op Code Word Size
  port (
    Clk : in std_logic;
    Rst : in std_logic;                -- Active Low
    DATA_IN     : in std_logic_vector (31 downto 0);      --DATA FROM DRAM
    IRAM_OUT    : in std_logic_vector (31 downto 0);      --WRITE INTO IR
    IRAM_ADDR   : out std_logic_vector (31 downto 0);     --ADDR TO THE IR (mostly PC)
    DATA_OUT    : out std_logic_vector (31 downto 0);     --DATA TO DRAM
    DATA_ADDR   : out std_logic_vector (31 downto 0);     --ADDR TO DRAM
    BLC         : out std_logic_vector(1 downto 0);
    MEM_WR      : out std_logic;
    MEM_RD      : out std_logic
    );    
end DLX;  

architecture dlx_rtl of DLX is

 --------------------------------------------------------------------
 -- Components Declaration
 --------------------------------------------------------------------

  -- Datapath
  component Datapath is 
  port (
    -- Logic signals
    CLK, RST    : in std_logic;

    -- Data signals
    DATA_IN     : in std_logic_vector (31 downto 0);      --DATA FROM DRAM
    IRAM_OUT    : in std_logic_vector (31 downto 0);      --WRITE INTO IR
    IRAM_ADDR   : out std_logic_vector (31 downto 0);
    DATA_OUT    : out std_logic_vector (31 downto 0);     --DATA TO DRAM
    DATA_ADDR   : out std_logic_vector (31 downto 0);     --ADDR TO DRAM
    BMP         : inout std_logic;      -- USED TO REPORT A CASE OF MISPREDICTED BRANCH FROM THE DATAPATH
    STALL       : out std_logic_vector(1 downto 0);
    -- Control signals
   
  -- ID Control Signals
    ID_EN       : IN STD_LOGIC;
    RF_RD       : IN STD_LOGIC;
    SIGND       : IN STD_LOGIC;
    IMM_SEL     : IN STD_LOGIC;
    BPR_EN      : IN STD_LOGIC; --branch prediction register enable used to turn on the BHT
   
  -- ALU Operation Code
    ALU_OPCODE  : IN aluOp;

  -- EX Control Signals
    EX_EN       : IN STD_LOGIC;
    ALUA_SEL   : IN STD_LOGIC;
    ALUB_SEL   : IN STD_LOGIC;
    UCB_EN        : IN STD_LOGIC;

  -- MEM Control Signals
    MEM_EN      : IN STD_LOGIC;
    MEM_DATA_SEL: IN STD_LOGIC;
    LD_SEL     : IN STD_LOGIC_VECTOR(2 downto 0);    --USED TO SELECT THE PROPER CONFIGURATION AT THE MEMORY OUTPUT (DEPENDING ON TYPE OF LOAD)
    ALR2_SEL    : IN STD_LOGIC;
    CWB_SEL     : IN STD_LOGIC_VECTOR(1 downto 0);    --CONDITION WRITE BACK SELECTOR
    
  -- WB Control signals
    WB_SEL      : IN STD_LOGIC;
    RF_WR       : IN STD_LOGIC;
    RF_MUX_SEL  : IN STD_LOGIC_VECTOR(1 downto 0)
);
end component;
  
  -- Control Unit
  component CU is
    generic (
      MICROCODE_MEM_SIZE :     integer := 62;  -- Microcode Memory Size, MUST BE EQUAL TO THE ADDRESS OF LAST INSTRUCTION
      FUNC_SIZE          :     integer := 11;  -- Func Field Size for R-Type Ops
      OP_CODE_SIZE       :     integer := 6;  -- Op Code Size
      IR_SIZE            :     integer := 32;  -- Instruction Register Size    
      CW_SIZE            :     integer := 26);  -- Control Word Size
  
      Port (
          Clk                : in  std_logic;  -- Clock
          Rst                : in  std_logic;  -- Reset:Active-Low
          STALL              : in std_logic_vector(1 downto 0);
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
  end component;

  ----------------------------------------------------------------
  -- Signals Declaration
  ----------------------------------------------------------------
  
  signal ALU_OPCODE_i : aluOp;
  signal STALL_CODE : std_logic_vector(1 downto 0);

  -- Instruction Register (IR) and Program Counter (PC) declaration
  signal IR_IN_i : std_logic_vector(IR_SIZE - 1 downto 0) := (others => '0');
  signal PC_i : std_logic_vector(PC_SIZE - 1 downto 0) := (others => '0');
  signal BMP_i : std_logic := '0';

  -- Instruction Ram Bus signals
  signal IRam_DOUT : std_logic_vector(IR_SIZE - 1 downto 0) := (others => '0');

  -- Datapath Bus signals
  signal PC_BUS_i : std_logic_vector(PC_SIZE -1 downto 0) := (others => '0');

  -- Control Unit Bus signals
  signal ID_EN_i : std_logic := '0';
  signal RF_RD_i : std_logic := '0';
  signal SIGND_i : std_logic := '0';
  signal IMM_SEL_i : std_logic := '0';
  signal BPR_EN_i : std_logic := '0';
  signal UCB_EN_i : std_logic := '0';
  signal EX_EN_i      : std_logic := '0';
  signal ALUA_SEL_i    : std_logic := '0';
  signal ALUB_SEL_i    : std_logic := '0';
  
  --MEM
  signal MEM_EN_i      : std_logic := '0';
  signal MEM_DATA_SEL_i: std_logic := '0';
  signal MEM_RD_i      : std_logic := '0';
  signal CS_i          : std_logic := '0';    --CHIP SELECT for the memory
  signal ALR2_SEL_i    : std_logic := '0';
  signal CWB_SEL_i      : std_logic_vector(1 downto 0) := (others => '0');
  signal LD_SEL_i    : std_logic_vector(2 downto 0) := (others => '0');

  -- WB 
  signal WB_SEL_i       : std_logic := '0';
  signal RF_WR_i        : std_logic := '0';
  signal RF_MUX_SEL_i      : std_logic_vector(1 downto 0) := (others => '0');


  --DRAM control signals 
  signal WR_mem : std_logic := '0';
  signal MEM_DataIn : std_logic_VECTOR(31 downto 0) := (others => '0');
  signal MEM_DataOut : std_logic_VECTOR(31 downto 0) := (others => '0');
  signal MEM_ADDR : std_logic_VECTOR(31 downto 0) := (others => '0');

  begin  -- DLX
    
    IRam_DOUT <= IRAM_OUT;
    
    -- Control Unit Instantiation
    CU_I: CU
      port map (
          Clk => Clk,  -- Clock
          Rst => Rst, 
          STALL => STALL_CODE,
          IR_IN => IRam_DOUT,
          BMP => BMP_i,
          ID_EN => ID_EN_i,
          RF_RD => RF_RD_i,
          SIGND => SIGND_i,
          IMM_SEL => IMM_SEL_i,
          BPR_EN => BPR_EN_i,
          UCB_EN => UCB_EN_i,
          ALU_OPCODE => ALU_OPCODE_i,
          EX_EN => EX_EN_i,
          ALUA_SEL => ALUA_SEL_i,
          ALUB_SEL => ALUB_SEL_i,
          MEM_EN => MEM_EN_i,
          MEM_DATA_SEL => MEM_DATA_SEL_i,
          MEM_RD => MEM_RD,
          MEM_WR => MEM_WR,
          CS => CS_i,
          MEM_BLC0 => BLC(0),
          MEM_BLC1 => BLC(1),
          LD_SEL0 => LD_SEL_i(0),
          LD_SEL1 => LD_SEL_i(1),
          LD_SEL2 => LD_SEL_i(2),
          ALR2_SEL => ALR2_SEL_i,
          CWB_SEL0 => CWB_SEL_i(0),
          CWB_SEL1 => CWB_SEL_i(1),
          WB_SEL => WB_SEL_i,
          RF_WR => RF_WR_i,
          RF_MUX_SEL0 => RF_MUX_SEL_i(0),
          RF_MUX_SEL1 => RF_MUX_SEL_i(1)
          );

    DATAP : Datapath
      port map(
        Clk => Clk,
        Rst => Rst,
        STALL => STALL_CODE,
        DATA_IN => DATA_IN,
        IRAM_OUT => IRam_DOUT,
        IRAM_ADDR => IRAM_ADDR,
        DATA_OUT => DATA_OUT,
        DATA_ADDR => DATA_ADDR,
        BMP => BMP_i,
        ID_EN => ID_EN_i,
        RF_RD => RF_RD_i,
        SIGND => SIGND_i,
        IMM_SEL => IMM_SEL_i,
        BPR_EN => BPR_EN_i,
        ALU_OPCODE => ALU_OPCODE_i,
        EX_EN => EX_EN_i,
        ALUA_SEL => ALUA_SEL_i,
        ALUB_SEL => ALUB_SEL_i,
        UCB_EN => UCB_EN_i,
        MEM_EN => MEM_EN_i,
        MEM_DATA_SEL => MEM_DATA_SEL_i,
        LD_SEL => LD_SEL_i,
        ALR2_SEL => ALR2_SEL_i,
        CWB_SEL => CWB_SEL_i,
        WB_SEL => WB_SEL_i,
        RF_WR => RF_WR_i,
        RF_MUX_SEL => RF_MUX_SEL_i
      );
    
    
end dlx_rtl;
