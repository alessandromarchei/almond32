library IEEE;

use IEEE.std_logic_1164.all;
use WORK.all;

entity tb_dlx is
end tb_dlx;

architecture TEST of tb_dlx is

    component DLX is
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
      end component;

      component DRAM is
        generic(ADDR_BUS_SIZE : integer := 32;
        DATA_BUS_SIZE : integer := 32);
Port (  CLOCK : in std_logic;
        Rst : in  std_logic;
        WR : in std_logic;
        RD : in std_logic;
        BLC : in std_logic_VECTOR(1 downto 0); -- Byte lane control
        ADDR : in  std_logic_VECTOR(ADDR_BUS_SIZE - 1 downto 0);
        DataIn : in  std_logic_VECTOR(DATA_BUS_SIZE - 1 downto 0);
        DataOut : out  std_logic_VECTOR(DATA_BUS_SIZE - 1 downto 0));
    end component;


    component IRAM is
        generic (
          RAM_DEPTH : integer := 48;
          I_SIZE : integer := 32);
        port (
          Rst  : in  std_logic;
          Addr : in  std_logic_vector(I_SIZE - 1 downto 0);
          Dout : out std_logic_vector(I_SIZE - 1 downto 0)
          );
      end component;

      constant SIZE_IR      : integer := 32;       -- Instruction Register Size
      constant SIZE_PC      : integer := 32;       -- Program Counter Size
      constant SIZE_ALU_OPC : integer := 6;        -- ALU Op Code Word Size in case explicit coding is used
      signal Clock: std_logic := '0';
      signal Reset: std_logic := '0';

        signal DRAM_IN : std_logic_vector(31 downto 0);
        signal DRAM_OUT : std_logic_vector(31 downto 0);
        signal DRAM_ADDR : std_logic_vector(31 downto 0);
        signal IRAM_DATA : std_logic_vector(31 downto 0);
        signal IRAM_ADDR : std_logic_vector(31 downto 0);
        signal DRAM_DATA : std_logic_vector(31 downto 0);
        signal MEM_WR_t : std_logic;
        signal MEM_RD_t : std_logic;
        signal BLC : std_logic_vector(1 downto 0);


        begin
        -- instance of DLX

	ALMOND_32: DLX
        Generic Map (SIZE_IR, SIZE_PC) -- SIZE_ALU_OPC)   
	Port Map (Clock, Reset, DATA_IN => DRAM_OUT, DATA_ADDR => DRAM_ADDR, DATA_OUT => DRAM_IN,
        IRAM_OUT => IRAM_DATA, BLC => BLC, IRAM_ADDR => IRAM_ADDR,MEM_WR => MEM_WR_t, MEM_RD => MEM_RD_t);

        DMEM : DRAM
        PORT MAP(Clock => CLOCK, Rst => Reset, WR => MEM_WR_t, RD => MEM_RD_t, BLC=> BLC, ADDR => DRAM_ADDR,
        DataIn => DRAM_IN, DataOut => DRAM_OUT);

        IMEM : IRAM generic map(1023,32)
        port map(Rst => Reset, Addr => IRAM_ADDR, Dout => IRAM_DATA);

        PCLOCK : process(Clock)
	begin
		Clock <= not(Clock) after 0.5 ns;	
	end process;
	
        Reset <= '1', '0' after 5 ns;
       

end TEST;

