library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.myTypes.all;

--THIS MODULE SERVES AS A DRIVER FOR THE WRITEBACK MUX IN ORDER TO IMPLEMENT OPERATIONS SUCH AS SGE, SLE, SNE, SEQ etc..
--IT NEEDS TO KNOW WHICH TYPE OF OPERATION THE ALU IS PERFORMING, AND THE RESULT OF THE PSW (PROCESSOR STATUS WORD)
--THE ONLY INPUT IT NEEDS IS AluOp, GENERATED BY THE CU AND SENT TO THE ALU


--THE GENERATED OUTPUT IS THE SELECTOR OF A MULTIPLEXER : 
--COND_SEL = "00" ==> NORMAL OPERATION WITHOUT NEED FOR THIS MODULE
--COND_SEL = "01" ==> CONDITION VERIFIED : WRITE "1111....111"
--COND_SEL = "10" ==> CONDITION NOT VERIFIED : WRITE "0000....000"


entity CWBU is
    port (
        CLOCK : in std_logic;
        ALU_OP : in aluOp; -- input signals to select the operation to be performed by the ALU block
        PSW : in std_logic_vector(6 downto 0);
        COND_SEL : out std_logic_vector(1 downto 0);
        CWB_SEL : in std_logic_vector(1 downto 0);
        CWB_MUW_SEL : out std_logic_vector(1 downto 0)
        );
end CWBU;

architecture BEHAVIORAL of CWBU is

    signal ALUPIPE : aluOp;     --PIPE REG NEEDED TO SYNCHRONIZE THE ALUOPCODE 


    begin

    --PIPELINING PROCESS IN ORDER TO SYNCHRONIZE THE INCOMING ALUOPCODE
    PIPE: process(CLOCK)
        begin
            if CLOCK'event and CLOCK = '1' then  -- rising clock edge
            ALUPIPE <= ALU_OP;
            end if;
        end process;
    

    OPERATION : process(ALUPIPE,PSW)
    begin

    --for each type of operation contained in ALUPIPE, the content of PSW drives the output
    case ALUPIPE is
        
        when OP_SNE=> 
            CWB_MUW_SEL <= "10";
            if PSW(5) = '1' then COND_SEL <= "01";
            else COND_SEL <= "10";
            end if;
        
        when OP_SLT => 
            CWB_MUW_SEL <= "10";
            if PSW(0) = '1' then COND_SEL <= "01";
            else COND_SEL <= "10";
            end if;
        
        when OP_SGT => 
            CWB_MUW_SEL <= "10";
            if PSW(2) = '1' then COND_SEL <= "01";
            else COND_SEL <= "10";
            end if;
        
        when OP_SLE => 
            CWB_MUW_SEL <= "10";
            if PSW(1) = '1' then COND_SEL <= "01";
            else COND_SEL <= "10";
            end if;
        
        when OP_SGE => 
            CWB_MUW_SEL <= "10";
            if PSW(3) = '1' then COND_SEL <= "01";
            else COND_SEL <= "10";
            end if;

        when others => 
            CWB_MUW_SEL <= CWB_SEL;
            COND_SEL <= "00";

        end case;
    end process;

end architecture;