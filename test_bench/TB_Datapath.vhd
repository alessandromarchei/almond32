library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.myTypes.all;  -- Assicurati che myTypes e constants siano inclusi nel tuo progetto
use work.constants.all;

entity Datapath_TB is
end Datapath_TB;

architecture TB_ARCH of Datapath_TB is
  -- Dichiarazioni dei segnali per il test bench
    signal CLK: std_logic := '0'
    signal RST: std_logic := '0';  
    signal IRAM, DATA_IN: std_logic_vector(31 downto 0);
    signal DATA_OUT, PC, IR, ALR, DATA_ADDR: std_logic_vector(31 downto 0);
    signal PSW: std_logic_vector(6 downto 0);
    signal IR_EN, NPC_EN, PC_EN, RF_EN, RF_WR, RF_CALL, RF_RET, RF_RD1, RF_RD2, RF_FILL, RF_SPILL, RIMM_EN, RA_EN, RB_EN, PSW_EN: std_logic;
    signal ALUA_SEL, ALUB_SEL, J_SEL: std_logic_vector(1 downto 0);
    signal RWB1_EN, RWB2_EN, ALR_EN, CIN_EN, B2_EN, LMD_EN, WB_SEL, MEM_ADDR_SEL, MEM_DATA_SEL, SIGN: std_logic;

signal ALU_OP: aluOp;


  -- Dichiarazione del componente under test (UUT)
  component Datapath
    port (
        -- Logic signals
        CLK, RST: in std_logic;

        -- Data signals
        IRAM: in std_logic_vector (31 downto 0);
        DATA_IN: in std_logic_vector (31 downto 0);        
        DATA_OUT: out std_logic_vector (31 downto 0);
        PC:   out std_logic_vector (31 downto 0);
        IR:   out std_logic_vector (31 downto 0);
        ALR:  out std_logic_vector (31 downto 0);
        DATA_ADDR: out std_logic_vector (31 downto 0);
        PSW: out std_logic_vector (6 downto 0); -- 0-5 comparator bit, 6 Cout

        -- Control signals
        IR_EN, NPC_EN, PC_EN, RF_EN, RF_WR, RF_CALL, RF_RET, RF_RD1, RF_RD2, RF_FILL, RF_SPILL,
         RIMM_EN, RA_EN, RB_EN, PSW_EN: in std_logic;
        ALUA_SEL, ALUB_SEL, J_SEL: in std_logic_vector(1 downto 0);
        RWB1_EN, RWB2_EN, ALR_EN, CIN_EN: in std_logic;
        B2_EN, LMD_EN: in std_logic;
        WB_SEL, MEM_ADDR_SEL, MEM_DATA_SEL, SIGN: in std_logic;
        ALU_OP: in aluOp
    );
  end component;

begin
  -- Collegamento del componente under test (UUT)
  DUT : Datapath
        port map (
            CLK => CLK,
            RST => RST,
            IRAM => IRAM,
            DATA_IN => DATA_IN,
            DATA_OUT => DATA_OUT,
            PC => PC,
            IR => IR,
            ALR => ALR,
            DATA_ADDR => DATA_ADDR,
            PSW => PSW,
            IR_EN => IR_EN,
            NPC_EN => NPC_EN,
            PC_EN => PC_EN,
            RF_EN => RF_EN,
            RF_WR => RF_WR,
            RF_CALL => RF_CALL,
            RF_RET => RF_RET,
            RF_RD1 => RF_RD1,
            RF_RD2 => RF_RD2,
            RF_FILL => RF_FILL,
            RF_SPILL => RF_SPILL,
            RIMM_EN => RIMM_EN,
            RA_EN => RA_EN,
            RB_EN => RB_EN,
            PSW_EN => PSW_EN,
            ALUA_SEL => ALUA_SEL,
            ALUB_SEL => ALUB_SEL,
            J_SEL => J_SEL,
            RWB1_EN => RWB1_EN,
            RWB2_EN => RWB2_EN,
            ALR_EN => ALR_EN,
            CIN_EN => CIN_EN,
            B2_EN => B2_EN,
            LMD_EN => LMD_EN,
            WB_SEL => WB_SEL,
            MEM_ADDR_SEL => MEM_ADDR_SEL,
            MEM_DATA_SEL => MEM_DATA_SEL,
            SIGN => SIGN,
            ALU_OP => ALU_OP
        );

  -- Processo per generare il segnale di clock
  process
  begin
    CLK <= '0';
    wait for 5 ns;  -- Puoi regolare la frequenza del clock cambiando il periodo qui
    CLK <= '1';
    wait for 5 ns;
  end process;

  -- Processo per inizializzare il sistema
  process
  begin
    RST <= '1';  -- Porta il sistema in uno stato di reset
    wait for 10 ns;
    RST <= '0';  -- Rilascia il reset
    wait for 10 ns;
    -- Puoi inizializzare gli altri segnali di input qui se necessario
    -- ...
    wait;
  end process;

  -- Processo di simulazione
  process
  begin
    -- Configura i segnali di input per la simulazione
    IRAM <= (others => '0');  -- Inizializza IRAM con valori appropriati
    DATA_IN <= (others => '0');  -- Inizializza DATA_IN con valori appropriati
    -- Imposta i segnali di controllo
    -- ...

    wait for 10 ns;  -- Attendi un po' prima di iniziare la simulazione effettiva

    -- Genera delle attività di input qui se necessario
    -- ...

    -- Attendi per un periodo di simulazione sufficiente
    wait for 100 ns;

    -- Verifica i segnali di output qui e esegui le asserzioni se necessario
    -- ...

    wait;
  end process;

end TB_ARCH;
