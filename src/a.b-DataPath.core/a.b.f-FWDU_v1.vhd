library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--THIS MODULE IMPLEMENTS THE FORWARDING DETECTION UNIT, WHICH IS FUNDAMENTAL IN THIS ARCHITECTURE
--SINCE IT AVOID ALL TYPES OF DATA HAZARDS THAT OCCURS WHEN AN INSTRUCTION IS READING A REGISTER WHILE 
--ITS CONTENT IS NOT UPDATED YET

--THE OUTPUTS OF THIS MODULES WILL DRIVE 4 MULTIPLEXER PLACED IN THE DATAPATH OF THE DLX.
--THIS UNIT PERFORM A HIGH NUMBER OF COMPARISON IN A COMBINATORIAL MANNER, TACKLING 3 INSTRUCTION REGISTERS AT A TIME
--THE FIRST IN THE DECODE STAGE AND THE LAST 2 IN THE EXECUTION STAGE AND MEM STAGE.

--FOR EVERY TYPE OF INSTRUCTION (R, I, J) THE HW SELECTS AND CHECKS COMMONALITIES BETWEEN THE DESTINATION REGISTERS 
--OF INSTRUCTIONS THAT ARE CURRENTLY IN THE EX AND MEM STAGE WITH THE ONE INSIDE THE DECODE STAGE.

--IF THAT OCCURS, A FORWARDING IS PERFORMED AND THE OUTPUT DATA OF THE MEM OR ALUOUT IS FED BACK INTO THE ALU INPUT OPERANDS

entity FWDU is
    generic(IR_SIZE : integer := 32);
    port (
        CLOCK : in std_logic;
        RESET: in std_logic;
        EN : in std_logic;
        IR : in std_logic_vector(IR_SIZE - 1 downto 0);
        FWD_A : out std_logic_vector(1 downto 0);
        FWD_B : out std_logic_vector(1 downto 0);
        FWD_B2 : out std_logic;
        ZDU_SEL: out std_logic_vector(1 downto 0)
        );
end FWDU;

architecture BEHAVIORAL of FWDU is

    signal IR_EX, IR_MEM : std_logic_vector(IR_SIZE - 1 downto 0);    --used to store the previous instruction wrt the current one
    signal DESTINATION_DEC, DESTINATION_EX, DESTINATION_MEM: integer := 0;     --used to be compared to the 2 operands
    signal IR_OP1I, IR_OP1R, IR_OP2R, IR_OP1F, IR_OP2F, IR_EX_OP1I, IR_EX_OP1R, IR_EX_OP2R, IR_EX_OP1F, IR_EX_OP2F : integer := 0 ;
    signal OP_DEC, OP_EX, OP_MEM : integer := 0;
    signal NOT_JMP_EX, NOT_JMP_MEM, IS_LOAD: boolean := false;
    signal FWD_A_tmp, FWD_B_tmp, ZDU_SEL_tmp: std_logic_vector(1 downto 0);
    signal FWD_B2_tmp, FWD_B2_tmp2: std_logic;
  
   
    begin

    IR_OP1I <= conv_integer(unsigned(IR(25 downto 21))); --OPERAND OF INSTRUCTION I-TYPE IN DECODE STAGE
    IR_OP1R <= conv_integer(unsigned(IR(25 downto 21))); --1st OPERAND OF INSTRUCTION R-TYPE IN DECODE STAGE
    IR_OP1F <= conv_integer(unsigned(IR(25 downto 21))); --1st OPERAND OF INSTRUCTION F-TYPE IN DECODE STAGE (MULT)
    IR_OP2R <= conv_integer(unsigned(IR(20 downto 16))); --2nd OPERAND OF INSTRUCTION R-TYPE IN DECODE STAGE
    IR_OP2F <= conv_integer(unsigned(IR(20 downto 16))); --2nd OPERAND OF INSTRUCTION F-TYPE IN DECODE STAGE (MULT)
    
    IR_EX_OP1I <= conv_integer(unsigned(IR_EX(25 downto 21))); -- OPERAND OF INSTRUCTION I-TYPE IN EX STAGE
    IR_EX_OP1R <= conv_integer(unsigned(IR_EX(25 downto 21))); --1st OPERAND OF INSTRUCTION R-TYPE IN EX STAGE
    IR_EX_OP1F <= conv_integer(unsigned(IR_EX(25 downto 21))); --1st OPERAND OF INSTRUCTION F-TYPE IN EX STAGE (MULT)
    IR_EX_OP2R <= conv_integer(unsigned(IR_EX(20 downto 16))); --2nd OPERAND OF INSTRUCTION R-TYPE IN EX STAGE
    IR_EX_OP2F <= conv_integer(unsigned(IR_EX(20 downto 16))); --2nd OPERAND OF INSTRUCTION F-TYPE IN EX STAGE (MULT)

    OP_DEC <= conv_integer(unsigned(IR(31 downto 26))); --OPCODE OF INSTRUCTION IN DECODE STAGE
    OP_EX <= conv_integer(unsigned(IR_EX(31 downto 26))); -- OPCODE OF INSTRUCTION IN EXE STAGE
    OP_MEM <= conv_integer(unsigned(IR_MEM(31 downto 26))); -- OPCODE OF INSTRUCTION IN MEM STAGE
        
    DESTINATION_DEC <= conv_integer(unsigned(IR(15 downto 11))) when (IR(31 downto 26) = "000000" or IR(31 downto 26) = "000001") else
        conv_integer(unsigned(IR(20 downto 16)));

    DESTINATION_EX <= conv_integer(unsigned(IR_EX(15 downto 11))) when (IR_EX(31 downto 26) = "000000" or IR_EX(31 downto 26) = "000001") else
                      conv_integer(unsigned(IR_EX(20 downto 16)));
    
    DESTINATION_MEM <= conv_integer(unsigned(IR_MEM(15 downto 11))) when (IR_MEM(31 downto 26) = "000000" or IR_MEM(31 downto 26) = "000001") else
        conv_integer(unsigned(IR_MEM(20 downto 16)));

    NOT_JMP_MEM <= (((OP_MEM /= 2) and (OP_MEM /= 3) and (OP_MEM /= 4) and (OP_MEM /= 5) and (OP_MEM /= 18) and (OP_MEM /= 19)));
    NOT_JMP_EX <= (((OP_EX /= 2) and (OP_EX /= 3) and (OP_EX /= 4) and (OP_EX /= 5) and (OP_EX /= 18) and (OP_EX /= 19)));
    IS_LOAD <= (OP_EX = 32 or OP_EX = 33 or OP_EX = 35 or OP_EX = 36);

    --DELAYING THE OUTPUT SIGNALS IN ORDER TO PRESENT THEM AT THE RIGHT TIME WHEN THE FORWARDING OCCURS
    IR_PIPE : process(CLOCK, RESET)
    begin
        
        if RESET = '1' then
            IR_EX <= (others => '0');
            IR_MEM <= (others => '0');
            
        elsif CLOCK'event and CLOCK = '1' and EN = '1' then  -- rising clock edge
            
            IR_MEM <= IR_EX; 
            IR_EX <= IR;
            FWD_A <= FWD_A_tmp;
            FWD_B <= FWD_B_tmp;
            ZDU_SEL <= ZDU_SEL_tmp;
            
            FWD_B2 <= FWD_B2_tmp2;
            FWD_B2_tmp2 <= FWD_B2_tmp;


        end if;
    end process;

    -- FORWARDING_A
    FWD_A_tmp <= "00" when ((NOT_JMP_EX and DESTINATION_EX = 0) or (NOT_JMP_MEM and DESTINATION_MEM = 0)) else
                 "01" when ((NOT_JMP_EX and OP_DEC = 0 and IR_OP1R = DESTINATION_EX) or (NOT_JMP_EX and OP_DEC /= 0 and IR_OP1I = DESTINATION_EX) or (NOT_JMP_EX and OP_DEC = 1 and IR_OP1F = DESTINATION_EX))  else
                 "10" when ((NOT_JMP_MEM and OP_DEC = 0 and IR_OP1R = DESTINATION_MEM) or (NOT_JMP_MEM and OP_DEC /= 0 and IR_OP1I = DESTINATION_MEM) or (NOT_JMP_MEM and OP_DEC = 1 and IR_OP1F = DESTINATION_MEM) or (NOT_JMP_MEM and OP_DEC /= 0 and IR_OP1R = DESTINATION_EX and IS_LOAD)) else
                 "00";
                
    -- FORWARDING_B
    FWD_B_tmp <= "00" when ((NOT_JMP_EX and DESTINATION_EX = 0) or (NOT_JMP_MEM and DESTINATION_MEM = 0)) else
                 "01" when ((NOT_JMP_EX and OP_DEC = 0 and IR_OP2R = DESTINATION_EX and not IS_LOAD) or (NOT_JMP_EX and OP_DEC = 1 and IR_OP2F = DESTINATION_EX)) else
                 "10" when ((NOT_JMP_MEM and OP_DEC = 0 and IR_OP2R = DESTINATION_MEM) or (NOT_JMP_MEM and OP_DEC = 1 and IR_OP2F = DESTINATION_MEM) or (NOT_JMP_MEM and OP_DEC = 0 and IR_OP2R = DESTINATION_EX and IS_LOAD)) else
                 "00";
    
    --FORWARDING ZDU
    ZDU_SEL_tmp <=  "00" when (DESTINATION_EX = 0 or DESTINATION_MEM = 0) else
                    "01" when ((OP_DEC=4 or OP_DEC=5 ) and (DESTINATION_EX = IR_OP1I)) else 
                    "10" when ((OP_DEC=4 or OP_DEC=5 ) and (DESTINATION_MEM = IR_OP1I)) else
                    "00";

    --FORWARDING B2
    FWD_B2_tmp <=   '0' when (DESTINATION_EX = 0 or DESTINATION_DEC = 0) else
                    '1' when ((OP_DEC = 40) or (OP_DEC = 41) or (OP_DEC = 43)) and (DESTINATION_EX = DESTINATION_DEC) else
                    '0';

end architecture;